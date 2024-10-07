import 'package:caller/authentication/auth/auth_gate.dart';
import 'package:caller/firebase/firebase_services.dart';
import 'package:caller/firebase/userDataModel.dart';
import 'package:caller/pages/home/redirectScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<ControlsModel> controls;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controls = FirebaseServices().getControls();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AuthGate()
    )
    );
  }
}
