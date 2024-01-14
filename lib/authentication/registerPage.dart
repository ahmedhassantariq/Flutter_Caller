import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../myTextfield.dart';
import 'auth/auth_service.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password do not match")));
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailAndPassword(
          emailController.text, passwordController.text,
        fNameController.text, lNameController.text
      );
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
                  const Icon(Icons.app_registration, size: 100, color: Colors.lightGreen),
                  const SizedBox(height: 25),
                  const Text("Let's create an Account.", style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 25),
                  MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                  const SizedBox(height: 25),
                  MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                  const SizedBox(height: 25),
                  MyTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obscureText: true),
                  const SizedBox(height: 25),
                  CupertinoButton(minSize: 50,onPressed: signUp,color: Colors.green,borderRadius: BorderRadius.circular(25),pressedOpacity: 0.7, child: const Text("Sign up with Email")),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a Member?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Login Now", style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}