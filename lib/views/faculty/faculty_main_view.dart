import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/layout/main_layout.dart';
import 'package:roomexaminationschedulingsystem/route_guards.dart';

class FacultyMainView extends StatefulWidget {
  const FacultyMainView({super.key});

  @override
  State<FacultyMainView> createState() => _FacultyMainViewState();
}

class _FacultyMainViewState extends State<FacultyMainView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('faculty', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      index: 0,
      content: Center(
        child: Text('Faculty Main View'),
      ),
      title: 'Exam Schedules',
      role: Role.faculty
    );
  }
}
