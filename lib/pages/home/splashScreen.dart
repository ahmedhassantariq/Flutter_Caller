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
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: controls,
            builder: (builder, snapshot){
          if(snapshot.hasError){
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Line Share", style: TextStyle(color: Colors.lightGreen, fontSize: 36, fontWeight: FontWeight.w700)),
                SizedBox(height: 8.0),
                Text("An Error has Occurred!", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Line Share", style: TextStyle(color: Colors.lightGreen, fontSize: 36, fontWeight: FontWeight.w700)),
                SizedBox(height: 8.0),
                CircularProgressIndicator(color: Colors.lightGreen, strokeWidth: 7.0, strokeCap: StrokeCap.round,)
              ],
            );
          }
          return !snapshot.data!.isReview ? AuthGate(controls: snapshot.requireData,) : const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Line Share", style: TextStyle(color: Colors.lightGreen, fontSize: 36, fontWeight: FontWeight.w700)),
              SizedBox(height: 8.0),
              CircularProgressIndicator(color: Colors.lightGreen, strokeWidth: 7.0, strokeCap: StrokeCap.round,)
            ],
          );
            }),
      ),
    );
  }
}
