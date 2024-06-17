import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/course.dart';

enum Mode{update, create}

class CourseDialogForm extends StatefulWidget {
  const CourseDialogForm({
    super.key,
    required this.mode,
    this.course,
    required this.onRefresh
  });

  final void Function() onRefresh;
  final Mode mode;
  final Course? course;

  @override
  State<CourseDialogForm> createState() => _CourseDialogFormState();
}

class _CourseDialogFormState extends State<CourseDialogForm> {
  final _form = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.course != null){
      codeController.text = widget.course!.code!;
      titleController.text = widget.course!.title!;
    }
  }


  @override
  Widget build(BuildContext context) {

    void addCourse(Course course) async{
      await course.addCourse();
      widget.onRefresh();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Course Added!"),
      ));
    }

    void updateCourse(Course course) async{
      await course.updateCourse();
      widget.onRefresh();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Course Updated!"),
      ));
    }

    void submitCourse() async {
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return;
      }
      _form.currentState!.save();

      if (widget.mode == Mode.create){
        addCourse(Course(
          context: context,
          title: titleController.text,
          code: codeController.text
        ));
      } else {
        updateCourse(Course(
          context: context,
          title: titleController.text,
          code: codeController.text,
          id: widget.course!.id!
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
                        ? 'Add Course'
                        : 'Update Course',
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
              const Text('Code:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Course Code start must not be empty';
                  }
                  return null;
                },
                controller: codeController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter Course Code'
                ),
              ),
              const SizedBox(height: 25),
              const Text('Descriptive Title:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Course Title start must not be empty';
                  }
                  return null;
                },
                controller: titleController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter Course Descriptive Title'
                ),
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
                        onPressed: submitCourse,
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
