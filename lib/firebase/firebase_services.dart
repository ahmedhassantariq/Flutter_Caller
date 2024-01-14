import 'dart:async';
import 'package:caller/firebase/userDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class FirebaseServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<ControlsModel> getControls() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await  _firestore.collection('settings').doc("controls").get();
    return ControlsModel.fromMap(doc);
  }

  Future<void> saveDeviceToken(String fcmToken) async {
    try{
      _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).update({
        'fcmToken': fcmToken,
      });
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

}
