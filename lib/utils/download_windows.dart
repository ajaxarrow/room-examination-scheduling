import 'package:path_provider/path_provider.dart';
import 'package:roomexaminationschedulingsystem/model/academic_year.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/utils/generate_file.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;


savePDF(List<Schedule> schedules, String academicYearID) async {
  final academicYear = await AcademicYear().getAcademicYearByID(academicYearID);
  var savedFile = await generatePdf(schedules, academicYearID);
  final directory = await getDownloadsDirectory();
  final filePath = p.join(
      directory!.path!,
      '${academicYear.yearStart} - ${academicYear.yearEnd} ${academicYear.semester} Exam Schedule.pdf'
  );
  final file = io.File(filePath);
  await file.writeAsBytes(savedFile, flush: true);
}

saveExcel(List<Schedule> schedules, String academicYearID) async {
  final academicYear = await AcademicYear().getAcademicYearByID(academicYearID);
  var savedFile = await generateExcel(schedules, academicYearID);
  final directory = await getDownloadsDirectory();
  final filePath = p.join(
    directory!.path!,
    '${academicYear.yearStart} - ${academicYear.yearEnd} ${academicYear.semester} Exam Schedule.xlsx'
  );
  final file = io.File(filePath);
  await file.writeAsBytes(savedFile, flush: true);
}