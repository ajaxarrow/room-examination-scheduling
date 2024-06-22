import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/layout/main_layout.dart';
import 'package:roomexaminationschedulingsystem/route_guards.dart';

class FacultySectionsView extends StatefulWidget {
  const FacultySectionsView({super.key});

  @override
  State<FacultySectionsView> createState() => _FacultySectionsViewState();
}

class _FacultySectionsViewState extends State<FacultySectionsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('faculty', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 2,
        content: Center(
          child: Text('Sections'),
        ),
        title: 'Sections',
        role: Role.faculty
    );
  }
}
