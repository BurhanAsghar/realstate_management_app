// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realstate_management_app/Auth/login_screen.dart';
import 'package:realstate_management_app/Auth/reg_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: CustomPaint(
                painter: CurvePainter(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height,
                      width: size.width,
                    ),
                  ],
                ),
              ),
            ),
            CustomPaint(
              painter: VerticalTrianglePainter(color: Colors.indigo),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 340,
                    width: 340,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 135,
                  ),
                  Text(
                    "Forgot password?",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 135,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.indigo,
                      maxLength: 50,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo)),
                          counterText: '',
                          labelText: "Type Your Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          floatingLabelStyle:
                              TextStyle(color: Colors.indigo, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    height: 290,
                  ),
                  InkWell(
                    onTap: () {
                      if (emailController.text.trim().isNotEmpty) {
                        resetPassword();
                      } else {
                        showToast("Incomplete fields");
                      }
                    },
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14),
                        decoration:
                            BoxDecoration(color: Colors.indigo, boxShadow: [
                          BoxShadow(
                            color: Colors.indigo,
                            spreadRadius: 0.8,
                            blurRadius: 0.5,
                          )
                        ]),
                        child: Center(
                          child: Text(
                            "SEND EMAIL",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SignupScreen();
                      }));
                    },
                    child: Text(
                      "Not Registered Yet, Sign Up !",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);

      showToast("Please check your email");
    } on Exception {
      showToast("Error");
    }
  }

  showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}
