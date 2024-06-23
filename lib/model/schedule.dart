import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/academic_year.dart';
import 'package:roomexaminationschedulingsystem/model/app_user.dart';
import 'package:roomexaminationschedulingsystem/model/course.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/display_mixin.dart';
import 'package:roomexaminationschedulingsystem/model/room.dart';
import 'package:roomexaminationschedulingsystem/model/section.dart';
import 'package:roomexaminationschedulingsystem/utils/format_date.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

  Future<Appointment> convertToAppointment(Map<String, dynamic> data, id) async {
    Timestamp startTimeStamp = data['timeStart'] as Timestamp;
    Timestamp endTimeStamp = data['timeEnd'] as Timestamp;

    DateTime dateTimeStart = startTimeStamp.toDate();
    DateTime dateTimeEnd = endTimeStamp.toDate();

    AppUser faculty = await AppUser().getUserById(data['facultyID'] as String);
    Room room = await Room().getRoomByID(data['roomID'] as String);
    Section section = await Section().getSectionById(data['sectionID'] as String);
    Course course = await Course().getCourseByID(data['courseID'] as String);

    // Retrieve color data as a dynamic list
    List<dynamic> colorData = data['color'] as List<dynamic>;

    // Cast each element of the color data to an integer
    List<int> colorIntegers = colorData.map((dynamic value) => value as int).toList();

    // Use the color integers to create a Color object
    Color color = Color.fromRGBO(
      colorIntegers[0],
      colorIntegers[1],
      colorIntegers[2],
      1.0, // Opacity
    );

    return Appointment(
        color: color,
        subject: """
        ${course.code} - ${section.name}
        ${room.name} - ${faculty.name}
        """,
        startTime: dateTimeStart,
        endTime: dateTimeEnd
      // startTime: DateTime(dateTimeStart.year, dateTimeStart.month, dateTimeStart.day, dateTimeStart.hour, dateTimeStart.minute),
      // endTime: DateTime(dateTimeEnd.year, dateTimeEnd.month, dateTimeEnd.day, dateTimeEnd.hour,dateTimeEnd.minute),
    );
  }

  Future<void> add() async {
    print('called');
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
  }

  Future<void> update() async {
    await schedules.doc(id).update({
      'courseID': courseID,
      'facultyID': facultyID,
      'roomID': roomID,
      'sectionID': sectionID,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
    });
  }

  Future<void> addSchedule() async {
    try {
      final querySchedules = await getSchedulesByRoomID(roomID!);
      if (querySchedules.isEmpty) {
        await add();
        return;
      }

      var conflictFound = false;

      for (var schedule in querySchedules) {
        if (schedule.roomID! == roomID) {
          var newStartTime = convertTimestampToDateTime(timeStart!);
          var newEndTime = convertTimestampToDateTime(timeEnd!);
          var currentStartTime = convertTimestampToDateTime(schedule.timeStart!);
          var currentEndTime = convertTimestampToDateTime(schedule.timeEnd!);

          if (newStartTime.day == currentStartTime.day || newStartTime.day == currentEndTime.day || newEndTime.day == currentEndTime.day || newEndTime.day == currentStartTime.day) {
            if ((newStartTime.isAfter(currentStartTime) && newStartTime.isBefore(currentEndTime)) || (newEndTime.isBefore(currentEndTime) && newEndTime.isAfter(currentStartTime))) {
              showError(
                  errorMessage: 'The selected room is occupied for the selected time and date!',
                  errorTitle: 'Room Conflict'
              );
              conflictFound = true;
              throw Exception('An error occurred');
              break;
            }

          }
        }
      }

      if (!conflictFound) {
        await add();
      }

    } on FirebaseException catch (e) {
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }


  Future<void> updateSchedule() async {
    try {
      final querySchedules = await getSchedulesByRoomID(roomID!);
      if (querySchedules.isEmpty) {
        await add();
        return;
      }

      var conflictFound = false;

      for (var schedule in querySchedules) {
        if (schedule.roomID! == roomID) {
          var newStartTime = convertTimestampToDateTime(timeStart!);
          var newEndTime = convertTimestampToDateTime(timeEnd!);
          var currentStartTime = convertTimestampToDateTime(schedule.timeStart!);
          var currentEndTime = convertTimestampToDateTime(schedule.timeEnd!);

          if (newStartTime.day == currentStartTime.day || newStartTime.day == currentEndTime.day || newEndTime.day == currentEndTime.day || newEndTime.day == currentStartTime.day) {
            if ((newStartTime.isAfter(currentStartTime) && newStartTime.isBefore(currentEndTime)) || (newEndTime.isBefore(currentEndTime) && newEndTime.isAfter(currentStartTime))) {
              if (schedule.id! == id) {
                await update();
              } else {
                showError(
                    errorMessage: 'The selected room is occupied for the selected time and date!',
                    errorTitle: 'Room Conflict'
                );
                conflictFound = true;
                throw Exception('An error occurred');
                break;
              }
            }
          }
        }
      }

      if (!conflictFound) {
        await update();
      }

    } on FirebaseException catch (e) {
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
  Future<List<Appointment>> getAppointments() async {
    QuerySnapshot querySnapshot = await schedules.get();
    List<Future<Appointment>> futureAppointments = querySnapshot.docs.map((doc) async {
      return await convertToAppointment(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
    return await Future.wait(futureAppointments);
  }


  Future<List<Schedule>> getSchedulesByRoomID(String id) async {
    QuerySnapshot querySnapshot =  await schedules
        .where('roomID', isEqualTo: id)
        .get();
    final result = querySnapshot.docs.map((doc) => Schedule.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }




}