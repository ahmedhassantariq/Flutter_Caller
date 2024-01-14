import 'package:caller/pages/home/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'authentication/auth/auth_gate.dart';
import 'authentication/auth/auth_service.dart';
import 'firebase/firebase_options.dart';
import 'firebase/firebase_services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(defaultTargetPlatform == TargetPlatform.android) {
    var devices = ["77D9C1BA6BDFF96411B2C82DA9D6EB13"];
    await MobileAds.instance.initialize();
    RequestConfiguration requestConfiguration = RequestConfiguration(
        testDeviceIds: devices);
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
      ChangeNotifierProvider(create: (context) => AuthService(),
        child: const MyApp(),
      )
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FirebaseServices>(create: (context)=>FirebaseServices()),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Line-Share ',
          home: SplashScreen(),
        ));
  }
}

