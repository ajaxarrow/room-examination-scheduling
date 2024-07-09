import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';
import 'package:roomexaminationschedulingsystem/model/app_user.dart';
import 'package:roomexaminationschedulingsystem/model/course.dart';
import 'package:roomexaminationschedulingsystem/model/room.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/model/section.dart';
import 'package:roomexaminationschedulingsystem/utils/format_date.dart';

enum Mode{update, create}
enum Type{start, end}

class ScheduleDialogForm extends StatefulWidget {
  const ScheduleDialogForm({
    super.key,
    required this.mode,
    this.schedule,
    required this.onRefresh,
    required this.role
  });
  
  final void Function() onRefresh;
  final Mode mode;
  final Schedule? schedule;
  final Role role;

  @override
  State<ScheduleDialogForm> createState() => _ScheduleDialogFormState();
}

class _ScheduleDialogFormState extends State<ScheduleDialogForm> {
  final _form = GlobalKey<FormState>();
  bool isLoading = true;
  String selectedCourse = '';
  String selectedRoom = '';
  String selectedSection = '';
  String selectedFaculty = '';
  TextEditingController proctorController = TextEditingController();
  List<DropdownMenuItem> courses = [];
  List<DropdownMenuItem> rooms = [];
  List<DropdownMenuItem> sections = [];
  List<DropdownMenuItem> faculties = [];
  DateTime scheduleDateStart = DateTime.now();
  TimeOfDay scheduleTimeStart= TimeOfDay.now();
  DateTime scheduleDateEnd = DateTime.now();
  TimeOfDay scheduleTimeEnd = TimeOfDay.now();


  Future<void> _selectDate(DateTime selectedDate, Type type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      if(type == Type.start){
        setState(() {
          scheduleDateStart = pickedDate;
        });
      } else {
        setState(() {
          scheduleDateEnd = pickedDate;
        });
      }
    }
  }

  Future<void> _selectTime(TimeOfDay selectedTime, Type type) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      if(type == Type.start){
        setState(() {
          scheduleTimeStart = pickedTime;
        });
      } else {
        setState(() {
          scheduleTimeEnd = pickedTime;
        });
      }
    }
  }

  void addSchedule(Schedule schedule) async{
    await schedule.addSchedule();
    widget.onRefresh();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Schedule Added!"),
    ));
  }

  void updateSchedule(Schedule schedule) async{
    await schedule.updateSchedule();
    widget.onRefresh();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Schedule Updated!"),
    ));
  }

  void submitSchedule() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    if(widget.mode == Mode.create){
      addSchedule(Schedule(
        context: context,
        facultyID: widget.role == Role.faculty ? FirebaseAuth.instance.currentUser!.uid! : selectedFaculty,
        courseID: selectedCourse,
        roomID: selectedRoom,
        sectionID: selectedSection,
        timeStart: convertToFirebaseTimestamp(scheduleDateStart, scheduleTimeStart),
        timeEnd: convertToFirebaseTimestamp(scheduleDateEnd, scheduleTimeEnd),
        proctor: proctorController.text
      ));
    } else {
      updateSchedule(Schedule(
        context: context,
        id: widget.schedule!.id!,
        facultyID: widget.role == Role.faculty ? FirebaseAuth.instance.currentUser!.uid! : selectedFaculty,
        courseID: selectedCourse,
        roomID: selectedRoom,
        sectionID: selectedSection,
        proctor: proctorController.text,
        timeStart: convertToFirebaseTimestamp(scheduleDateStart, scheduleTimeStart),
        timeEnd: convertToFirebaseTimestamp(scheduleDateEnd, scheduleTimeEnd)
      ));
    }
  }

  @override
  void initState() {
    courses.clear();
    rooms.clear();
    faculties.clear();
    sections.clear();
    super.initState();
    List<DropdownMenuItem<String>> tempCourses = [];
    List<DropdownMenuItem<String>> tempRooms = [];
    List<DropdownMenuItem<String>> tempSections = [];
    List<DropdownMenuItem<String>> tempFaculties = [];

    Future.wait([
      Course().getCourses(),
      Room().getRooms(),
      AppUser().getUsersbyRole('faculty'),
      Section().getSections()
    ]).then((List<dynamic> results) {
      var coursesList = results[0];
      var roomsList = results[1];
      var facultiesList = results[2];
      var sectionsList = results[3];

      for (var course in coursesList) {
        tempCourses.add(DropdownMenuItem(value: course.id, child: Text(course.code)));
      }
      for (var room in roomsList) {
        tempRooms.add(DropdownMenuItem(value: room.id, child: Text(room.name)));
      }
      for (var faculty in facultiesList) {
        tempFaculties.add(DropdownMenuItem(value: faculty.uid, child: Text(faculty.name)));
      }
      for (var section in sectionsList) {
        tempSections.add(DropdownMenuItem(value: section.id, child: Text(section.name)));
      }

      setState(() {
        courses = tempCourses;
        rooms = tempRooms;
        faculties = tempFaculties;
        sections = tempSections;

        // Assuming you have default values for selectedCourse, selectedRoom, etc., set them here
        selectedCourse = coursesList.isNotEmpty? coursesList[0].id : null;
        selectedRoom = roomsList.isNotEmpty? roomsList[0].id : null;
        selectedFaculty = facultiesList.isNotEmpty? facultiesList[0].uid : null;
        selectedSection = sectionsList.isNotEmpty? sectionsList[0].id : null;
      });

      if (widget.mode == Mode.update) {
        setState(() {
          proctorController.text = widget.schedule!.proctor!;
          selectedCourse = widget.schedule!.courseID!;
          selectedRoom = widget.schedule!.roomID!;
          selectedFaculty = widget.schedule!.facultyID!;
          selectedSection = widget.schedule!.sectionID!;
        });
        scheduleDateStart = convertTimestampToDateTime(widget.schedule!.timeStart!);
        scheduleDateEnd = convertTimestampToDateTime(widget.schedule!.timeEnd!);
        scheduleTimeStart = convertTimestampToTimeOfDay(widget.schedule!.timeStart!);
        scheduleTimeEnd = convertTimestampToTimeOfDay(widget.schedule!.timeEnd!);
      }

      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      // Handle error if any of the futures fail
      print("Failed to load data: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    Widget body;

    if(isLoading){
      body = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 70),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (courses.isEmpty || rooms.isEmpty || faculties.isEmpty || sections.isEmpty){
        body = const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OOPS!',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24
                ),
              ),
              SizedBox(height:  5),
              Text(
                  'There are empty data. Please check the sections, courses, and room data'
              )
            ],
          ),
        );
      } else {
        body = Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.mode == Mode.create
                        ? 'Add Schedule'
                        : 'Update Schedule',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded))
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Course: '),
                      const SizedBox(height: 8),
                      DropdownButton(
                          value: selectedCourse,
                          items: courses,
                          onChanged: (value){
                            setState(() {
                              selectedCourse = value;
                            });
                          }
                      ),
                    ],
                  ),
                  const SizedBox(width: 25,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Section: '),
                      const SizedBox(height: 8),
                      DropdownButton(
                          value: selectedSection,
                          items: sections,
                          onChanged: (value){
                            setState(() {
                              selectedSection = value;
                            });
                          }
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text('Room: '),
              const SizedBox(height: 8),
              DropdownButton(
                  value: selectedRoom,
                  items: rooms,
                  onChanged: (value){
                    setState(() {
                      selectedRoom = value;
                    });
                  }
              ),
              widget.role != Role.faculty ? const SizedBox(height: 15) : const SizedBox.shrink(),
              widget.role != Role.faculty ? const Text('Faculty: ') : const SizedBox.shrink(),
              widget.role != Role.faculty ? const SizedBox(height: 8) : const SizedBox.shrink(),
              widget.role != Role.faculty ? DropdownButton(
                  value: selectedFaculty,
                  items: faculties,
                  onChanged: (value){
                    setState(() {
                      selectedFaculty = value;
                    });
                  }
              ) : const SizedBox.shrink(),
              const SizedBox(height: 15),
              const Text('Proctor Name:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Proctor Name start must not be empty';
                  }
                  return null;
                },
                controller: proctorController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter Proctor Name'
                ),
              ),
              const SizedBox(height: 25),
              Text('Time Start: (Selected: ${formatTimestamp(convertToFirebaseTimestamp(scheduleDateStart, scheduleTimeStart))})', style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        _selectDate(scheduleDateStart, Type.start);
                      },
                      child: const Text('Select Start Date')
                  ),
                  const SizedBox(width: 5,),
                  ElevatedButton(
                      onPressed: (){
                        _selectTime(scheduleTimeStart, Type.start);
                      },
                      child: const Text('Select Start Time')
                  )
                ],
              ),
              const SizedBox(height: 25),
              Text('Time End: (Selected: ${formatTimestamp(convertToFirebaseTimestamp(scheduleDateEnd, scheduleTimeEnd))})', style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        _selectDate(scheduleDateEnd, Type.end);
                      },
                      child: const Text('Select End Date')
                  ),
                  const SizedBox(width: 5,),
                  ElevatedButton(
                      onPressed: (){
                        _selectTime(scheduleTimeEnd, Type.end);
                      },
                      child: const Text('Select End Time')
                  )
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffdae2f3),
                            padding: const EdgeInsets.symmetric(vertical: 19)
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff3b5ba9)
                            )
                        )
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 19)
                        ),
                        onPressed: submitSchedule,
                        child: const Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 16
                            )
                        )
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }


    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
          width: 400,
          child: body
      ),
    );
  }
}
