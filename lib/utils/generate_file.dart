import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:roomexaminationschedulingsystem/main.dart';
import 'package:roomexaminationschedulingsystem/model/academic_year.dart';
import 'package:roomexaminationschedulingsystem/model/app_user.dart';
import 'package:roomexaminationschedulingsystem/model/course.dart';
import 'package:roomexaminationschedulingsystem/model/room.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/model/section.dart';
import 'package:roomexaminationschedulingsystem/utils/format_date.dart';

Future<List<List<String>>> fetchScheduleData(List<Schedule> schedules) async {
  return Future.wait(schedules.map((schedule) async {
    Course course = await Course().getCourseByID(schedule.courseID!);
    Room room = await Room().getRoomByID(schedule.roomID!);
    AppUser faculty = await AppUser().getUserById(schedule.facultyID!);
    Section section = await Section().getSectionById(schedule.sectionID!);

    return [
      '${formatTimestamp(schedule.timeStart!)} - ${formatTimestamp(schedule.timeEnd!)}',
      '${course.code} - ${course.title}',
      section.name ?? '',
      faculty.name ?? '',
      schedule.proctor ?? '',
      room.name ?? ''
    ];
  }).toList());
}


Future<Uint8List> generatePdf(List<Schedule> schedules, String academicYearID) async {
  final pdf = pw.Document();
  final academicYear = await AcademicYear().getAcademicYearByID(academicYearID);
  final scheduleData = await fetchScheduleData(schedules);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      orientation: pw.PageOrientation.landscape,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            children: [
              pw.Center(
                child: pw.Text(
                  '${academicYear.yearStart} - ${academicYear.yearEnd} ${academicYear.semester} Exam Schedule',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: [
                  'Time',
                  'Course',
                  'Section',
                  'Faculty',
                  'Proctor',
                  'Room'
                ],
                data: scheduleData,
              )
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}

Future<List<int>> generateExcel(List<Schedule> schedules, String academicYearID) async {
  var excel = Excel.createExcel();
  var sheet = excel['Exam Schedule'];

  final academicYear = await AcademicYear().getAcademicYearByID(academicYearID);
  String title = '${academicYear.yearStart} - ${academicYear.yearEnd} ${academicYear.semester} Exam Schedule';

  sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("F1"));
  sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue(title);

  List<String> headers = ['Time', 'Course', 'Section', 'Faculty', 'Proctor', 'Room'];
  for (int i = 0; i < headers.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1)).value = TextCellValue(headers[i]);
  }

  for (int i = 0; i < schedules.length; i++) {
    Schedule schedule = schedules[i];

    Course course = await Course().getCourseByID(schedule.courseID!);
    Room room = await Room().getRoomByID(schedule.roomID!);
    AppUser faculty = await AppUser().getUserById(schedule.facultyID!);
    Section section = await Section().getSectionById(schedule.sectionID!);

    List<String> row = [
      '${formatTimestamp(schedule.timeStart!)} - ${formatTimestamp(schedule.timeEnd!)}',
      '${course.code} - ${course.title}',
      section.name ?? '',
      faculty.name ?? '',
      schedule.proctor ?? '',
      room.name ?? ''
    ];

    for (int j = 0; j < row.length; j++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 2)).value = TextCellValue(row[j]);
    }
  }

  // Save the Excel file
  excel.setDefaultSheet(sheet.sheetName);
  return excel.encode()!;
}

