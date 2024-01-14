import 'package:cloud_firestore/cloud_firestore.dart';

class UserCredentialsModel {
  final String uid;
  final String email;
  final String fcmToken;
  final Timestamp lastLogin;

  const UserCredentialsModel({
    required this.uid,
    required this.email,
    required this.fcmToken,
    required this.lastLogin
});

  factory UserCredentialsModel.fromMap(DocumentSnapshot<Map<String, dynamic>> documentSnapshot){
    return(UserCredentialsModel(
        email: documentSnapshot.get('email'),
        lastLogin: documentSnapshot.get('lastLogin'),
        fcmToken: documentSnapshot.get('fcmToken'),
        uid: documentSnapshot.get('uid')));
  }
}