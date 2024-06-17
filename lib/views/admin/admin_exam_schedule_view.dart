import 'package:flutter/material.dart';

import '../../layout/main_layout.dart';
import '../../route_guards.dart';

class AdminExamScheduleView extends StatefulWidget {
  const AdminExamScheduleView({super.key});

  @override
  State<AdminExamScheduleView> createState() => _AdminExamScheduleViewState();
}

class _AdminExamScheduleViewState extends State<AdminExamScheduleView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('admin', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 2,
        content: Center(
          child: Text('Exam Schedule'),
        ),
        title: 'Exam Schedule',
        role: Role.admin
    );
  }
}
