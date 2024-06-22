import 'package:roomexaminationschedulingsystem/data/programs.dart';

class Program{
  Program({
    required this.programName,
    required this.collegeName,
    required this.collegeAcronym
  });

  final String programName;
  final String collegeName;
  final String collegeAcronym;

  List<Program> fetchProgramsbyCollege(String name){
    return programs.where((program) => program.collegeName == name).toList();
  }
}