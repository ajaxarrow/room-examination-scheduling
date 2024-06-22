import 'package:roomexaminationschedulingsystem/data/programs.dart';

class Program{
  Program({
    this.programName,
    this.collegeName,
    this.collegeAcronym
  });

  final String? programName;
  final String? collegeName;
  final String? collegeAcronym;

  List<Program> fetchProgramsbyCollege(String name){
    return programs.where((program) => program.collegeName == name).toList();
  }

  Program fetchProgrambyName(String name){
    return programs.firstWhere((program) => program.programName == name);
  }
}