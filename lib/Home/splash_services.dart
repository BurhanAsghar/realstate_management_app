
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realstate_management_app/Auth/login_screen.dart';
import 'package:realstate_management_app/Home/home_screen.dart';


class SplashServices {
  Future<void> isLogin(BuildContext context) async {
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;

    if(user!=null){
      Timer(Duration(seconds: 5), () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen())));
    }else{
      Timer(Duration(seconds: 5), () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }

  }
}
