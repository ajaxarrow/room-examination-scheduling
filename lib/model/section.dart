import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/display_mixin.dart';

final CollectionReference sections = FirebaseFirestore.instance.collection('sections');

class Section with DisplayMixin{
  Section({
    this.context,
    this.id,
    this.name,
    this.program,
    this.college
  });
  
  final BuildContext? context;
  final String? id;
  final String? name;
  final String? program;
  final String? college;

  factory Section.fromMap(Map<String, dynamic> data, String id){
    return Section(
        id: id,
        name: data['name'],
        program: data['program'],
        college: data['college'],
    );
  }


  Future<void> addSection() async {
    try{
      await sections.add({
        'name': name,
        'program': program,
        'college': college
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> updateSection() async {
    try{
      await sections.doc(id).update({
        'name': name,
        'program': program,
        'college': college
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteSection() async {
    try{
      await sections.doc(id).delete();
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<List<Section>> getSections() async{
    QuerySnapshot querySnapshot = await sections.get();
    final result = querySnapshot.docs.map((doc) => Section.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }

  Future<List<Section>> getSectionsByCollege(String college) async{
    if(college == 'All'){
      QuerySnapshot querySnapshot = await sections.get();
      final result = querySnapshot.docs.map((doc) => Section.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      return result;
    } else {
      QuerySnapshot querySnapshot = await sections
          .where('college', isEqualTo: college)
          .get();
      final result = querySnapshot.docs.map((doc) => Section.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      return result;
    }
  }
}