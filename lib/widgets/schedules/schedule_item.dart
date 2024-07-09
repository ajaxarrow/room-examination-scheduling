import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';
import 'package:roomexaminationschedulingsystem/model/app_user.dart';
import 'package:roomexaminationschedulingsystem/model/course.dart';
import 'package:roomexaminationschedulingsystem/model/room.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/model/section.dart';
import 'package:roomexaminationschedulingsystem/utils/format_date.dart';
import 'package:roomexaminationschedulingsystem/views/schedule_details_view.dart';
import 'package:roomexaminationschedulingsystem/widgets/schedules/schedule_dialog_form.dart';

class ScheduleItem extends StatefulWidget {
  const ScheduleItem({
    super.key,
    required this.schedule,
    required this.onRefresh,
    required this.role,
    required this.isCurrent
  });

  final void Function() onRefresh;
  final Schedule schedule;
  final Role role;
  final bool isCurrent;

  @override
  State<ScheduleItem> createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<ScheduleItem> {
  String faculty = 'Example Faculty';
  String course = 'Course';
  String room = 'Room';
  String section = 'Section';
  AppUser currentUser = AppUser();

  @override
  void initState() {
    super.initState();
    final id = FirebaseAuth.instance.currentUser?.uid!;
    Future.wait([
      AppUser().getUserById(widget.schedule.facultyID!),
      Section().getSectionById(widget.schedule.sectionID!),
      Room().getRoomByID(widget.schedule.roomID!),
      Course().getCourseByID(widget.schedule.courseID!),
      AppUser().getUserById(id!)
    ]).then((List<dynamic> results) {
      AppUser user = results[0];
      Section sectionList = results[1];
      Room roomList = results[2];
      Course courseList = results[3];
      AppUser queryUser = results[4];
      setState(() {
        faculty = user.name!;
        section = sectionList.name!;
        room = roomList.name!;
        course = courseList.code!;
        currentUser = queryUser;
      });
    }).catchError((error) {
      print("Failed to load data: $error");
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    bool isLarge = MediaQuery.of(context).size.width > 900;
    void showScheduleFormDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  ScheduleDialogForm(
                    schedule: widget.schedule,
                    mode: Mode.update,
                    onRefresh: widget.onRefresh,
                    role: widget.role
                  )
                ],
              )
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context){
                return ScheduleDetailsView(
                  proctor: widget.schedule.proctor!,
                  isCurrent: widget.isCurrent,
                  role: widget.role,
                  course: course,
                  room: room,
                  faculty: faculty,
                  section: section,
                  schedule: widget.schedule,
                  currentUser: currentUser,
                );
              })
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 15
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                          '$course - $section',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16
                          )
                      ),
                      const Spacer(),
                      Text(faculty)
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(room)
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      isLarge ? Text('Time: ${formatTimestamp(widget.schedule!.timeStart!)} - ${formatTimestamp(widget.schedule!.timeEnd!)}') : const SizedBox.shrink(),
                      const Spacer(),
                      (isLarge && widget.isCurrent && (currentUser.role != 'faculty' || FirebaseAuth.instance.currentUser!.uid! == widget.schedule.facultyID!)) ? TextButton.icon(
                          onPressed: showScheduleFormDialog,
                          label: const Text('Edit'),
                          icon: const Icon(Icons.edit,
                              size: 16)
                      ) : const SizedBox.shrink(),
                    ],
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}
