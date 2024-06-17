import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/display_mixin.dart';


final CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');

class Room with DisplayMixin{
  Room({
    this.name,
    this.context,
    this.type,
    this.id
  });

  final BuildContext? context;
  final String? id;
  final String? name;
  final String? type;

  factory Room.fromMap(Map<String, dynamic> data, String id){
    return Room(
      id: id,
      name: data['name'],
      type: data['type']
    );
  }

  Future<void> addRoom() async {
    try{
      await rooms.add({
        'name': name,
        'type': type
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> updateRoom() async {
    try{
      await rooms.doc(id).update({
        'name': name,
        'type': type
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteRoom() async {
    try{
      await rooms.doc(id).delete();
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<List<Room>> getRooms() async{
    QuerySnapshot querySnapshot = await rooms.get();
    final result = querySnapshot.docs.map((doc) => Room.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }


}