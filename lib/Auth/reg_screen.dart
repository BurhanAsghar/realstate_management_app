// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool showPass = false;
  bool showCPass = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

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
                child: SizedBox(
                  height: size.height,
                  width: size.width,
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
                  // Container(
                  //   color: Colors.white,
                  //   child: CustomPaint(
                  //     painter: CurvePainter(),
                  //   ),
                  // ),
                  SizedBox(
                    height: 135,
                  ),
                  Text(
                    "Welcome, Sign Up to continue",
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
                    height: 30,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.indigo,
                      obscureText: showPass ? false : true,
                      maxLength: 50,
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  showPass ? showPass = false : showPass = true;
                                });
                              },
                              child: showPass
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility)),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo)),
                          counterText: '',
                          labelText: "Type Your Password",
                          labelStyle: TextStyle(fontSize: 14),
                          floatingLabelStyle:
                              TextStyle(color: Colors.indigo, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextField(
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.indigo,
                      obscureText: showCPass ? false : true,
                      maxLength: 50,
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  showCPass
                                      ? showCPass = false
                                      : showCPass = true;
                                });
                              },
                              child: showCPass
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility)),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo)),
                          counterText: '',
                          labelText: "Retype Your Password",
                          labelStyle: TextStyle(fontSize: 14),
                          floatingLabelStyle:
                              TextStyle(color: Colors.indigo, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    height: 125,
                  ),
                  InkWell(
                    onTap: () {
                      if (emailController.text.trim().isEmpty ||
                          passwordController.text.trim().isEmpty ||
                          confirmPasswordController.text.trim().isEmpty) {
                        showToast("Incomplete fields");
                      } else {
                        if (passwordController.text.trim() ==
                            confirmPasswordController.text.trim()) {
                          signUp();
                        } else {
                          showToast("The passwords don't match");
                        }
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
                            "SIGN UP",
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
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              milliseconds:
                                  250), // Adjust the duration as needed
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 1.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: LoginScreen(),
                            );
                          },
                        ),
                      );
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }), (route) => false);
                    },
                    child: Text(
                      "Already Registered, Sign In !",
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

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);

      emailController.text = "";
      passwordController.text = "";
      confirmPasswordController.text = "";
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
