import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/course.dart';
import 'package:roomexaminationschedulingsystem/widgets/courses/course_dialog_form.dart';


class CourseItem extends StatefulWidget {
  const CourseItem({
    super.key,
    required this.course,
    required this.onRefresh
  });

  final void Function()? onRefresh;
  final Course course;

  @override
  State<CourseItem> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  @override
  Widget build(BuildContext context) {

    void showCourseFormDialog() {
      showDialog(
        context: context,
        builder: (ctx) =>
          SimpleDialog(
            children: [
              CourseDialogForm(
                mode: Mode.update,
                course: widget.course,
                onRefresh: widget.onRefresh!
              )
            ],
          )
      );
    }

    return Card(
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
                      widget.course.code!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: showCourseFormDialog,
                    label: const Text('Edit'),
                    icon: const Icon(Icons.edit,
                        size: 16)
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(widget.course.title!),
                ],
              )
            ],
          )
      ),
    );
  }
}
