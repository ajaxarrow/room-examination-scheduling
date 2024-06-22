import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../model/course.dart';
import '../../route_guards.dart';
import '../../widgets/courses/course_dialog_form.dart';
import '../../widgets/courses/course_list.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';

class AdminCoursesView extends StatefulWidget {
  const AdminCoursesView({super.key});

  @override
  State<AdminCoursesView> createState() => _AdminCoursesViewState();
}

class _AdminCoursesViewState extends State<AdminCoursesView> {
  List<Course> _courses = [];

  Future<void> fetchCourses() async {
    _courses.clear();
    _courses = await Course().getCourses();
  }

  void _refreshList(){
    setState(() {

    });
  }

  void _removeCourse(String id) async {
    await Course(id: id).deleteCourse();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Course Deleted!"),
        )
    );
  }

  void showCourseFormDialog() {
    showDialog(
        context: context,
        builder: (ctx) =>
            SimpleDialog(
              children: [
                CourseDialogForm(
                    mode: Mode.create,
                    onRefresh: _refreshList
                )
              ],
            )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('admin', context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCourses(),
        builder: (ctx, snapshot) {
          Widget body;
          if (snapshot.connectionState == ConnectionState.waiting) {
            body = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            body = Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Widget mainContent = const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OOPS!',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize:  50
                    ),
                  ),
                  SizedBox(height:  5),
                  Text(
                      'There are no courses added.'
                  )
                ],
              ),
            );

            if (_courses.isNotEmpty) {
              mainContent = CourseList(
                  onRefresh: _refreshList,
                  courses: _courses,
                  onRemoveCourse: _removeCourse
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _courses.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15,  bottom:  5),
                  child: Text(
                    'Courses',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize:  18
                    ),
                  ),
                ) : const SizedBox.shrink(),
                Expanded(child: mainContent),
              ],
            );
          }

          return MainLayout(
            role: Role.admin,
            title: 'Courses',
            index: 4,
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: RefreshIndicator(
                  onRefresh: () async{
                    await fetchCourses();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Course List Updated"),
                    ));
                  },
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: body,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: showCourseFormDialog,
                      child: const Icon(Icons.add),
                    ),
                  )
              ),
            ),
          );

        }
    );
  }

}
