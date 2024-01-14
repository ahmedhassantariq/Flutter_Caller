import 'package:caller/firebase/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../controllers/notifications/notification_services.dart';
class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();


  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async{
    _googleAuthProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    _googleAuthProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      String fcmToken = "";
      NotificationServices().getDeviceToken().then((value) => fcmToken = value);
      _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastLogin': Timestamp.now(),
        'fcmToken' : fcmToken,
      });
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(String email, password, String firstName, String lastName) async {
    String fcmToken = "";
    NotificationServices().getDeviceToken().then((value) => fcmToken = value);
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'fcmToken': fcmToken,
        'lastLogin': Timestamp.now(),
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  Future<void> signOut () async {
    return await FirebaseAuth.instance.signOut();
  }


}