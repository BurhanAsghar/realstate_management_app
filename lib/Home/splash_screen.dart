import 'package:flutter/material.dart';
import 'package:realstate_management_app/Home/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState(){
    super.initState();
    splashScreen.isLogin(context);
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.white,
        body:Center(
            child:Image(image: AssetImage('assets/images/logo.png'),height: 150,
            )
        )
    );
  }
}