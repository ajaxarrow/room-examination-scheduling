import 'dart:convert';
import 'package:roomexaminationschedulingsystem/model/academic_year.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/utils/generate_file.dart';
import 'package:web/web.dart' as web;


savePDF(List<Schedule> schedules, String academicYearID) async {
  final academicYear = await AcademicYear().getAcademicYearByID(academicYearID);
  var savedFile = await generatePdf(schedules, academicYearID);
  List<int> fileInts = List.from(savedFile);
  web.HTMLAnchorElement()
    ..href = "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}"
    ..setAttribute("download", "${academicYear.yearStart} - ${academicYear.yearEnd} ${academicYear.semester} Exam Schedule.pdf")
    ..click();
}

saveExcel(List<Schedule> schedules, String academicYearID) async {
  final academicYear = await AcademicYear().getAcademicYearByID(academicYearID);
  var savedFile = await generateExcel(schedules, academicYearID);
  List<int> fileInts = List.from(savedFile);
  web.HTMLAnchorElement()
    ..href = "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}"
    ..setAttribute("download", "${academicYear.yearStart} - ${academicYear.yearEnd} ${academicYear.semester} Exam Schedule.xlsx")
    ..click();
}