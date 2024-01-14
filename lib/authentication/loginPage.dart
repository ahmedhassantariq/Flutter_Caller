import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myTextfield.dart';
import 'auth/auth_service.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi, size: 100, color: Colors.lightGreen,),
                  const SizedBox(height: 25),
                  const Text("Welcome back. You\'ve been missed.", style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 25),
                  MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                  const SizedBox(height: 25),
                  MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                  const SizedBox(height: 25),
                  CupertinoButton(minSize: 50,onPressed: signIn,color: Colors.green,borderRadius: BorderRadius.circular(25),pressedOpacity: 0.7, child: const Text("Sign in with Email")),
                  const SizedBox(height: 25),
                             const SizedBox(height: 25),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a member?"),
                        const SizedBox(width: 4,),
                        GestureDetector(
                            onTap: widget.onTap,
                            child: const Text("Register Now", style: TextStyle(fontWeight: FontWeight.bold))
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}