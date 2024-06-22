import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/themes/theme.dart';
import 'package:roomexaminationschedulingsystem/views/admin/admin_courses_view.dart';
import 'package:roomexaminationschedulingsystem/views/admin/admin_exam_schedule_view.dart';
import 'package:roomexaminationschedulingsystem/views/admin/admin_main_view.dart';
import 'package:roomexaminationschedulingsystem/views/admin/admin_rooms_view.dart';
import 'package:roomexaminationschedulingsystem/views/admin/admin_sections_view.dart';
import 'package:roomexaminationschedulingsystem/views/admin/users_view.dart';
import 'package:roomexaminationschedulingsystem/views/auth_view.dart';
import 'package:roomexaminationschedulingsystem/views/faculty/faculty_main_view.dart';
import 'package:roomexaminationschedulingsystem/views/faculty/faculty_sections_view.dart';
import 'package:roomexaminationschedulingsystem/views/redirect_view.dart';
import 'package:roomexaminationschedulingsystem/views/registrar/registrar_courses_view.dart';
import 'package:roomexaminationschedulingsystem/views/registrar/registrar_exam_schedule_view.dart';
import 'package:roomexaminationschedulingsystem/views/registrar/registrar_main_view.dart';
import 'package:roomexaminationschedulingsystem/views/registrar/registrar_rooms_view.dart';
import 'package:roomexaminationschedulingsystem/views/registrar/registrar_sections_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/redirect',
      routes: {
        '/redirect': (context) => const RedirectView(),
        '/auth': (context) => const AuthView(),
        '/faculty/main': (context) => const FacultyMainView(),
        '/faculty/sections': (context) => const FacultySectionsView(),
        '/registrar/main': (context) => const RegistrarMainView(),
        '/registrar/schedule': (context) => const RegistrarExamScheduleView(),
        '/registrar/rooms': (context) => const RegistrarRoomsView(),
        '/registrar/courses': (context) => const RegistrarCoursesView(),
        '/registrar/sections': (context) => const RegistrarSectionsView(),
        '/admin/main': (context) => const AdminMainView(),
        '/admin/users': (context) => const UsersView(),
        '/admin/schedule': (context) => const AdminExamScheduleView(),
        '/admin/rooms': (context) => const AdminRoomsView(),
        '/admin/courses': (context) => const AdminCoursesView(),
        '/admin/sections': (context) => const AdminSectionsView()
      },
    );
  }
}
