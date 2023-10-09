// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realstate_management_app/Auth/reg_screen.dart';
import 'package:realstate_management_app/Home/home_screen.dart';

import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPass = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

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
                  SizedBox(
                    height: 135,
                  ),
                  Text(
                    "Welcome, Sign In to continue",
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
                    height: 90,
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
                    height: 70,
                  ),
                  InkWell(
                    onTap: () {
                      if (emailController.text.trim().isEmpty ||
                          passwordController.text.trim().isEmpty) {
                        showToast("Incomplete fields");
                      } else {
                        signIn();
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
                            "SIGN IN",
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
                              child: SignupScreen(),
                            );
                          },
                        ),
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SignupScreen();
                      }));
                    },
                    child: Text(
                      "Not Registered Yet, Sign Up !",
                      style: TextStyle(fontSize: 14, color: Colors.blue
                      ),

                    ),
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
                              child: ForgotPasswordScreen(),
                            );
                          },
                        ),
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ForgotPasswordScreen();
                      }));
                    },
                    child: Text(
                      "Forgot password?",
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

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }), (route) => false);

      emailController.text = "";
      passwordController.text = "";
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

class VerticalTrianglePainter extends CustomPainter {
  final Color color;

  VerticalTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

   // path.moveTo(size.width / 2, size.height); // Move to the bottom-center point
    path.lineTo(0, 0); // Draw a line to the top-left point
    path.lineTo(size.width, 0); // Draw a line to the top-right point
    path.close(); // Close the path to complete the shape

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.indigo;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.29);
    path.quadraticBezierTo(
        size.width / 1.6, size.height / 2.7, size.width, size.height * 0.28);
    path.lineTo(size.width, 0.3);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
