import 'package:caller/firebase/userDataModel.dart';
import 'package:caller/pages/home/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_or_resgister.dart';

class AuthGate extends StatelessWidget {
  final ControlsModel controls;
  const AuthGate({
    required this.controls,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return HomePage(controls: controls);
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}