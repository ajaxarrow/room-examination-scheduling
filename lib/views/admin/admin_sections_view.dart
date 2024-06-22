import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/layout/main_layout.dart';
import 'package:roomexaminationschedulingsystem/route_guards.dart';

class AdminSectionsView extends StatefulWidget {
  const AdminSectionsView({super.key});

  @override
  State<AdminSectionsView> createState() => _AdminSectionsViewState();
}

class _AdminSectionsViewState extends State<AdminSectionsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('admin', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 5,
        content: Center(
          child: Text('Sections'),
        ),
        title: 'Sections',
        role: Role.admin
    );
  }
}
