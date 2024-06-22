import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/display_mixin.dart';

final _firebase = FirebaseAuth.instance;
final CollectionReference users = FirebaseFirestore.instance.collection('users');


class AppUser with DisplayMixin{
  AppUser({
    this.name,
    this.email,
    this.password,
    this.context,
    this.uid,
    this.role,
    this.isActive
  });

  final String? uid;
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final BuildContext? context;
  final bool? isActive;

  factory AppUser.fromMap(Map<String, dynamic> data, id) {
    return AppUser(
      uid: data['id'],
      name: data['name'],
      email: data['email'],
      password: data['password'],
      role: data['role'],
      isActive: data['isActive']
    );
  }


  Future<void> register() async {
    try{
      UserCredential userCredential = await _firebase.createUserWithEmailAndPassword(
          email: email!,
          password: password!
      );

      await users.add({
        'id': userCredential.user!.uid,
        'name': name,
        'email': email,
        'role': role,
        'isActive': isActive
      });
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Authentication Error!'
      );
      return;

    }
  }

  Future<void> login() async {
    try{
      final user = await getUserByEmail(email!);
      if(user.isActive!){
        if (user.role == 'faculty'){
          print('faculty bitch');
          await _firebase.signInWithEmailAndPassword(
              email: email!,
              password: password!
          );
        } else if (user.role == 'registrar'){
          print('registrar bitch');
          await _firebase.signInWithEmailAndPassword(
              email: email!,
              password: password!
          );
        } else if (user.role == 'admin'){
          print('admin bitch');
          await _firebase.signInWithEmailAndPassword(
              email: email!,
              password: password!
          );
        } else if (user.role == 'student') {
          showError(
              errorMessage: 'This account is prohibited for this module',
              errorTitle: 'Authentication Error'
          );
        }
      } else {
        showError(
            errorMessage: 'This account is disabled. Please contact the admin',
            errorTitle: 'Authentication Error'
        );
      }
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Authentication Error!'
      );
      return;
    }
  }

  Future<AppUser> getUserById(String id) async {
    QuerySnapshot querySnapshot =  await users
        .where('id', isEqualTo: id)
        .get();
    final result = querySnapshot.docs.map((doc) =>
        AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result[0];
  }

  Future<AppUser> getUserbyIDv2(String id) async {
    DocumentSnapshot docSnapshot = await users.doc(id).get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Convert the document data to an AppUser object
      AppUser user = AppUser.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      return user;
    } else {
      // Handle the case where the document does not exist
      throw Exception('User with ID $id not found');
    }
  }

  Future<String> getUserRoleById(String id) async {
    QuerySnapshot querySnapshot =  await users
        .where('id', isEqualTo: id)
        .get();

    final result = querySnapshot.docs.map((doc) =>
        AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result[0].role!;
  }


  Future<AppUser> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot =  await users
        .where('email', isEqualTo: email)
        .get();

    final result = querySnapshot.docs.map((doc) =>
        AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

    if (result.isEmpty){
      showError(errorMessage: "User doesn't exist", errorTitle: 'Authentication Error!');
      return AppUser();
    } else {
      return result[0];
    }
  }

  Future<void> updateUser() async {
    try{
      await users.doc(uid).update({
        'name': name!,
        'isActive': isActive,
        'role': role,
      });
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<List<AppUser>> getUsers() async {
    QuerySnapshot querySnapshot = await users
        .where('role', whereIn: ['faculty', 'registrar'])
        .get();
    final allUsers = querySnapshot.docs.map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allUsers;
  }

  Future<List<AppUser>> getUsersbyRole(String role) async {
    QuerySnapshot querySnapshot = await users
        .where('role', isEqualTo: role)
        .get();
    final allUsers = querySnapshot.docs.map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allUsers;
  }



}
