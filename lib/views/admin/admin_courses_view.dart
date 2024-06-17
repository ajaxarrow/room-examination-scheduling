import 'package:flutter/material.dart';

import '../../layout/main_layout.dart';
import '../../route_guards.dart';

class AdminCoursesView extends StatefulWidget {
  const AdminCoursesView({super.key});

  @override
  State<AdminCoursesView> createState() => _AdminCoursesViewState();
}

class _AdminCoursesViewState extends State<AdminCoursesView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('admin', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 4,
        content: Center(
          child: Text('Courses'),
        ),
        title: 'Courses',
        role: Role.admin
    );
  }
}
