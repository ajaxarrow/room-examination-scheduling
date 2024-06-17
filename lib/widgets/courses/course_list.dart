import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/course.dart';
import 'package:roomexaminationschedulingsystem/widgets/courses/course_item.dart';

class CourseList extends StatelessWidget {
  const CourseList({
    super.key,
    required this.onRefresh,
    required this.courses,
    required this.onRemoveCourse
  });

  final void Function(String id) onRemoveCourse;
  final List<Course> courses;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (ctx, index) =>
          Dismissible(
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).colorScheme.error.withOpacity(0.85),
              ),

              margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16
              ),

            ),
            key: ValueKey(courses[index]),
            onDismissed: (direction){
              onRemoveCourse(courses[index].id!);
            },
            child: CourseItem(
              onRefresh: onRefresh,
              course: courses[index],
            )
          )
    );
  }
}
