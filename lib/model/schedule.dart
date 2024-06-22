import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/academic_year.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/display_mixin.dart';

final CollectionReference schedules = FirebaseFirestore.instance.collection('schedules');

class Schedule with DisplayMixin{
  Schedule({
    this.id,
    this.context,
    this.roomID,
    this.sectionID,
    this.courseID,
    this.facultyID,
    this.timeEnd,
    this.timeStart,
    this.createdAt,
    this.academicYearID,
    this.color
  });

  final BuildContext? context;
  final String? id;
  final String? roomID;
  final String? sectionID;
  final String? courseID;
  final String? facultyID;
  final String? academicYearID;
  final Timestamp? timeStart;
  final Timestamp? timeEnd;
  final Timestamp? createdAt;
  final List<int>? color;


  factory Schedule.fromMap(Map<String, dynamic> data, id){
    List<int> colorData = (data['color'] as List<dynamic>).cast<int>();

    return Schedule(
      id: id,
      courseID: data['courseID'],
      facultyID: data['facultyID'],
      roomID: data['roomID'],
      sectionID: data['sectionID'],
      timeStart: data['timeStart'],
      timeEnd: data['timeEnd'],
      createdAt: data['createdAt'],
      academicYearID: data['academicYearID'],
      color: colorData
    );
  }

  Future<void> addSchedule() async {
    try {
      final academicYear = await AcademicYear().getDefault();
      await schedules.add({
        'courseID': courseID,
        'facultyID': facultyID,
        'roomID': roomID,
        'sectionID': sectionID,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'academicYearID': academicYear.id,
        'createdAt': FieldValue.serverTimestamp(),
        'color': getRandomColor()
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> updateSchedule() async {
    try {
      await schedules.doc(id).update({
        'courseID': courseID,
        'facultyID': facultyID,
        'roomID': roomID,
        'sectionID': sectionID,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteSchedule() async {
    try {
      await schedules.doc(id).delete();
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  List<int> getRandomColor(){
    List<int> colorInts = [];
    Random random = Random();
    for (int j = 0; j < 3; j++) {
      colorInts.add(random.nextInt(256));
    }
    return colorInts;
  }

  Future<List<Schedule>> getSchedules() async {
    QuerySnapshot querySnapshot =  await schedules.get();
    final result = querySnapshot.docs.map((doc) => Schedule.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }


}