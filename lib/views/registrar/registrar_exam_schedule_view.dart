import 'package:flutter/material.dart';

import '../../layout/main_layout.dart';
import '../../route_guards.dart';

class RegistrarExamScheduleView extends StatefulWidget {
  const RegistrarExamScheduleView({super.key});

  @override
  State<RegistrarExamScheduleView> createState() => _RegistrarExamScheduleViewState();
}

class _RegistrarExamScheduleViewState extends State<RegistrarExamScheduleView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('registrar', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 1,
        content: Center(
          child: Text('Exam Schedule'),
        ),
        title: 'Exam Schedules',
        role: Role.registrar
    );
  }
}
