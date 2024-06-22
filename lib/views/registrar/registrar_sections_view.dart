import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/layout/main_layout.dart';
import 'package:roomexaminationschedulingsystem/route_guards.dart';

class RegistrarSectionsView extends StatefulWidget {
  const RegistrarSectionsView({super.key});

  @override
  State<RegistrarSectionsView> createState() => _RegistrarSectionsViewState();
}

class _RegistrarSectionsViewState extends State<RegistrarSectionsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('registrar', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 4,
        content: Center(
          child: Text('Sections'),
        ),
        title: 'Sections',
        role: Role.registrar
    );
  }
}
