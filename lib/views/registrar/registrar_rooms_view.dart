import 'package:flutter/material.dart';

import '../../layout/main_layout.dart';
import '../../route_guards.dart';

class RegistrarRoomsView extends StatefulWidget {
  const RegistrarRoomsView({super.key});

  @override
  State<RegistrarRoomsView> createState() => _RegistrarRoomsViewState();
}

class _RegistrarRoomsViewState extends State<RegistrarRoomsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('registrar', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 2,
        content: Center(
          child: Text('Rooms'),
        ),
        title: 'Rooms',
        role: Role.registrar
    );
  }
}
