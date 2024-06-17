
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/academic_year.dart';

enum Mode{update, create}

class AcademicYearDialogForm extends StatefulWidget {
  const AcademicYearDialogForm({
    super.key,
    this.academicYear,
    this.mode,
    this.onAddAcademicYear,
    this.onUpdateAcademicYear
  });

  final void Function()? onAddAcademicYear;
  final void Function()? onUpdateAcademicYear;
  final Mode? mode;
  final AcademicYear? academicYear;

  @override
  State<AcademicYearDialogForm> createState() => _AcademicYearDialogFormState();
}

class _AcademicYearDialogFormState extends State<AcademicYearDialogForm> {
  final _form = GlobalKey<FormState>();
  final yearStartController = TextEditingController();
  final yearEndController = TextEditingController();
  String selectedSemester = '1st Semester';
  bool isDefault = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.academicYear != null){
      yearStartController.text = widget.academicYear!.yearStart!;
      yearEndController.text = widget.academicYear!.yearEnd!;
      setState(() {
        isDefault = widget.academicYear!.isDefault!;
        selectedSemester = widget.academicYear!.semester!;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    void addAcademicYear(AcademicYear academicYear) async{
      await academicYear.addAcademicYear();
      widget.onAddAcademicYear!();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Academic Year Added!"),
      ));
    }

    void updateAcademicYear(AcademicYear academicYear) async{
      await academicYear.updateAcademicYear();
      widget.onUpdateAcademicYear!();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Academic Year Updated!"),
      ));
    }

    void submitActivity() async {
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return;
      }
      _form.currentState!.save();

      if (widget.mode == Mode.create){
        addAcademicYear(AcademicYear(
          context: context,
          yearStart: yearStartController.text,
          yearEnd: yearEndController.text,
          isDefault: isDefault,
          semester: selectedSemester,
        ));
      } else {
        updateAcademicYear(AcademicYear(
          context: context,
          yearStart: yearStartController.text,
          yearEnd: yearEndController.text,
          isDefault: isDefault,
          id: widget.academicYear!.id!,
          semester: selectedSemester,
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        child:   Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.mode == Mode.create
                        ? 'Add Academic Year'
                        : 'Update Academic Year',
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
              const SizedBox(height: 25),
              const Text('Year Start:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Year start must not be empty';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                controller: yearStartController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter Year Start'
                ),
              ),
              const SizedBox(height: 25),
              const Text('Year End:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Year end must not be empty';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                controller: yearEndController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.comment),
                    hintText: 'Enter End Year'
                ),
              ),
              const SizedBox(height: 25),
              const Text('Semester:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButton(
                  value: selectedSemester,
                  items: const [
                    DropdownMenuItem(
                        value: '1st Semester',
                        child: Text('1st Semester')
                    ),
                    DropdownMenuItem(
                        value: '2nd Semester',
                        child: Text('2nd Semester')
                    ),
                    DropdownMenuItem(
                        value: 'Midyear',
                        child: Text('Midyear')
                    )
                  ],
                  onChanged: (value){
                    setState(() {
                      selectedSemester = value!;
                    });
                  }
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Switch(
                    value: isDefault,
                    onChanged: (value){
                      setState(() {
                        isDefault = value;
                      });
                    }
                  ),
                  Text(isDefault ? 'Default Academic Year' : 'Not Default Academic Year'),
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
                        onPressed: submitActivity,
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
        ),
      ),
    );
  }
}
