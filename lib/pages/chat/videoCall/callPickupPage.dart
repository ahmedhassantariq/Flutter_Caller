import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../controllers/chat/userDataModel.dart';

class CallPickUpPage extends StatefulWidget {
  final UserCredentialsModel sender;
  final RemoteMessage message;
  const CallPickUpPage({
    required this.sender,
    required this.message,
    super.key
  });

  @override
  State<CallPickUpPage> createState() => _CallPickUpPageState();
}

class _CallPickUpPageState extends State<CallPickUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.sender.email, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.call, color: Colors.green,size: 20,)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.call, color: Colors.red,size: 20,)),
        ],
      ),
    );
  }
}
