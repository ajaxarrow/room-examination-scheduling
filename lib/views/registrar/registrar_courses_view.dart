import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../route_guards.dart';

class RegistrarCoursesView extends StatefulWidget {
  const RegistrarCoursesView({super.key});

  @override
  State<RegistrarCoursesView> createState() => _RegistrarCoursesViewState();
}

class _RegistrarCoursesViewState extends State<RegistrarCoursesView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('registrar', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 3,
        content: Center(
          child: Text('Courses'),
        ),
        title: 'Courses',
        role: Role.registrar
    );
  }
}
