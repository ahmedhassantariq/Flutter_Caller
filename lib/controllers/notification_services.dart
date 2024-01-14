import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../firebase/firebase_services.dart';
class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted permission");

    } else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");

    } else {
      print("User denied permission");
    }
  }


  void initLocalNotifications(BuildContext context, RemoteMessage message){
    var androidInitialization = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitialization,
        iOS: iosInitialization
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: (payload){
      handleMessage(context, message);
    }
    );


  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if(defaultTargetPlatform == TargetPlatform.android){
        initLocalNotifications(context, message);
        showNotifications(message);
      } else if(kIsWeb) {
        showWebNotifications(context,message);
      }
    });
  }

  Future<void> showWebNotifications(BuildContext context,RemoteMessage message) async{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message: ${message.notification!.body.toString()}")));
  }
  Future<void> showNotifications(RemoteMessage message) async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "High Importance Notification",
      importance: Importance.max
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker'
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getDeviceToken() async {
    String? fcmToken = await messaging.getToken();
    FirebaseServices().saveDeviceToken(fcmToken.toString());
    print(fcmToken.toString());
    return fcmToken.toString();
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      FirebaseServices().saveDeviceToken(event.toString());
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async{
    //when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage!=null){
      // handleMessage(context, initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });

  }

  Future<void> handleMessage(BuildContext context, RemoteMessage message) async {
    if(message.data['type']=='chat'){

    }
  }



}