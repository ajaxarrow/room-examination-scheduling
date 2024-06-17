import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/app_user.dart';

Future<void> isRoleCorrect (String role, BuildContext context) async {
  final currentRole = await AppUser().getUserRoleById(FirebaseAuth.instance.currentUser!.uid!);

  if(role != currentRole){
    Navigator.of(context).pushReplacementNamed('/$currentRole/main');
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Route Prohibited!"),
    ));
  }
}
Future<void> isAuthenticated(String role, BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if(user == null){
    Navigator.of(context).pushReplacementNamed('/auth');
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Route Prohibited!"),
    ));
  } else {
    isRoleCorrect(role, context);
  }
}

Future<void> isNotAuthenticated(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  final currentRole = await AppUser().getUserRoleById(user!.uid!);

  if(user != null){
    Navigator.of(context).pushReplacementNamed('/$currentRole/main');
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Route Prohibited!"),
    ));
  }
}