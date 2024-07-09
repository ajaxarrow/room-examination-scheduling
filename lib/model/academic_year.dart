import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/display_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;
final CollectionReference academicYears = FirebaseFirestore.instance.collection('academicyears');

class AcademicYear with DisplayMixin{
  AcademicYear({
    this.id,

    this.context,
    this.registrarID,
    this.yearEnd,
    this.yearStart,
    this.isDefault,
    this.semester
  });

  final BuildContext? context;
  final String? yearStart;
  final String? yearEnd;
  final String? registrarID;
  final String? id;
  final bool? isDefault;
  final String? semester;


  factory AcademicYear.fromMap(Map<String, dynamic> data, String id){
    return AcademicYear(
      id: id,
      registrarID: data['registrarID'],
      yearEnd: data['yearEnd'],
      yearStart: data['yearStart'],
      isDefault: data['isDefault'],
      semester: data['semester']
    );
  }

  Future<void> addAcademicYear () async {
    try{
      if(isDefault == true){
        final hasDefault = await isThereDefault();
        if(hasDefault){
          showError(
              errorMessage: 'It is not possible to have two or more default academic years',
              errorTitle: 'Database Error!'
          );
          throw Exception('An error occurred');
          return;
        } else {
          await academicYears.add({
            'registrarID': _firebase.currentUser?.uid,
            'yearEnd': yearEnd,
            'yearStart': yearStart,
            'isDefault': isDefault,
            'semester': semester,
          });
        }
      } else {
        await academicYears.add({
          'registrarID': _firebase.currentUser?.uid,
          'yearEnd': yearEnd,
          'yearStart': yearStart,
          'isDefault': isDefault,
          'semester': semester,
        });
      }

    } on FirebaseException catch (e){
      showError(
        errorMessage: e.message!,
        errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> updateAcademicYear() async {
    try{
      if(isDefault == true){
        final hasDefault = await isThereDefault();
        if(hasDefault){
          final academicYear = await getDefault();
          if(academicYear.id ==  id){
            await academicYears.doc(id).update({
              'yearEnd': yearEnd,
              'yearStart': yearStart,
              'isDefault': isDefault,
              'semester': semester,
            });
          } else {
            showError(
                errorMessage: 'It is not possible to have two or more default academic years',
                errorTitle: 'Database Error!'
            );
            throw Exception('An error occurred');
            return;
          }
          return;
        } else {
          await academicYears.doc(id).update({
            'yearEnd': yearEnd,
            'yearStart': yearStart,
            'isDefault': isDefault,
            'semester': semester,
          });
        }
      } else {
        await academicYears.doc(id).update({
          'yearEnd': yearEnd,
          'yearStart': yearStart,
          'isDefault': isDefault
        });
      }

    } on FirebaseException catch (e){
      showError(
        errorMessage: e.message!,
        errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteAcademicYear() async {
    try{
      await academicYears.doc(id).delete();
    } on FirebaseException catch (e){
      showError(
        errorMessage: e.message!,
        errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<List<AcademicYear>> getAcademicYears() async {
    QuerySnapshot querySnapshot =  await academicYears.get();
    final allAcademicYears = querySnapshot.docs.map((doc) => AcademicYear.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allAcademicYears;
  }

  Future<bool> isThereDefault() async {
    QuerySnapshot querySnapshot =  await academicYears
        .where('isDefault', isEqualTo: true)
        .get();
    if(querySnapshot.docs.isEmpty){
      return false;
    } else {
      return true;
    }
  }

  Future<AcademicYear> getDefault() async {
    QuerySnapshot querySnapshot =  await academicYears
      .where('isDefault', isEqualTo: true)
      .get();
    final allAcademicYears = querySnapshot.docs.map((doc) => AcademicYear.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allAcademicYears[0];
  }

  Future<AcademicYear> getAcademicYearByID(String id) async {
    DocumentSnapshot docSnapshot = await academicYears.doc(id).get();
    if (docSnapshot.exists) {
      AcademicYear academicYear = AcademicYear.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      return academicYear;
    } else {
      // Handle the case where the document does not exist
      throw Exception('Room with ID $id not found');
    }
  }

}
