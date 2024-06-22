import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'mixins/display_mixin.dart';


final CollectionReference courses = FirebaseFirestore.instance.collection('courses');

class Course with DisplayMixin{
  Course({
    this.context,
    this.id,
    this.code,
    this.title
  });

  final BuildContext? context;
  final String? id;
  final String? code;
  final String? title;

  factory Course.fromMap(Map<String, dynamic> data, String id){
    return Course(
        id: id,
        code: data['code'],
        title: data['title']
    );
  }

  Future<void> addCourse() async {
    try{
      await courses.add({
        'code': code,
        'title': title
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> updateCourse() async {
    try{
      await courses.doc(id).update({
        'code': code,
        'title': title
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteCourse() async {
    try{
      await courses.doc(id).delete();
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<List<Course>> getCourses() async{
    QuerySnapshot querySnapshot = await courses.get();
    final result = querySnapshot.docs.map((doc) => Course.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }


}