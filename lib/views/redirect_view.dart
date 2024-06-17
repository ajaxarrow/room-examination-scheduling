import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/app_user.dart';
import 'package:roomexaminationschedulingsystem/views/faculty/faculty_main_view.dart';
import 'package:roomexaminationschedulingsystem/views/registrar/registrar_main_view.dart';
import 'admin/admin_main_view.dart';
import 'auth_view.dart';


class RedirectView extends StatelessWidget {
  const RedirectView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot){
          if (snapshot.hasData) {
            return FutureBuilder<AppUser>(
              future: AppUser().getUserByEmail(snapshot.data!.email!),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}'); // handle error
                } else if (userSnapshot.hasData) {
                  if (userSnapshot.data!.role == 'faculty') {
                    return const FacultyMainView();
                  } else if (userSnapshot.data!.role == 'registrar') {
                    return const RegistrarMainView();
                  } else {
                    return const AdminMainView();
                  }
                } else {
                  return const Scaffold(
                    body: Center(child: Text('No user found')),
                  );
                }
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else{
            return const AuthView();
          }
        }
    );
  }
}
