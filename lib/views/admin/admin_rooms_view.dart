import 'package:flutter/material.dart';

import '../../layout/main_layout.dart';
import '../../route_guards.dart';

class AdminRoomsView extends StatefulWidget {
  const AdminRoomsView({super.key});

  @override
  State<AdminRoomsView> createState() => _AdminRoomsViewState();
}

class _AdminRoomsViewState extends State<AdminRoomsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('admin', context);
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        index: 3,
        content: Center(
          child: Text('Rooms'),
        ),
        title: 'Rooms',
        role: Role.admin
    );
  }

}
