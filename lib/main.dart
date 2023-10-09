import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';
import 'package:realstate_management_app/Auth/login_screen.dart';
import 'package:realstate_management_app/Home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Get the initial network status
  var initialConnectivityResult = await Connectivity().checkConnectivity();

  runApp(MyApp(initialConnectivityResult: initialConnectivityResult));
}

Color getStatusColor(ConnectivityResult connectivityResult) {
  switch (connectivityResult) {
    case ConnectivityResult.none:
      return Colors.red; // No network connection, show red status bar.
    case ConnectivityResult.mobile:
    case ConnectivityResult.wifi:
      return Colors.green; // Online with either mobile or Wi-Fi, show green status bar.
    default:
      return Colors.transparent; // Default status bar color.
  }
}

class MyApp extends StatelessWidget {
  final ConnectivityResult initialConnectivityResult;

  MyApp({Key? key, required this.initialConnectivityResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SplashScreen(initialConnectivityResult: initialConnectivityResult),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final ConnectivityResult initialConnectivityResult;

  const SplashScreen({Key? key, required this.initialConnectivityResult}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isOnline = true;
  late Timer _userActivityTimer;

  @override
  void initState() {
    super.initState();

    // Initialize the user activity timer
    _userActivityTimer = Timer(const Duration(minutes: 5), () {
      logout(); // Logout the user after 5 minutes of inactivity
    });

    // Set the initial connectivity result
    isOnline = widget.initialConnectivityResult != ConnectivityResult.none;

    // Add a connectivity listener
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });
      // Update the status bar color when connectivity changes
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: getStatusColor(result),
      ));
    });

    // Simulate a delay for the splash screen
    Future.delayed(Duration(seconds: 5), () {
      navigateToNextScreen();
    });
  }

  void resetUserActivityTimer() {
    _userActivityTimer.cancel();
    _userActivityTimer = Timer(const Duration(minutes: 5), () {
      logout(); // Logout the user after 5 minutes of inactivity
    });
  }

  Future<void> performLogout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      // You can also perform additional cleanup or actions here if needed
      print('User logged out due to inactivity');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  void logout() {
    performLogout(); // Call the asynchronous function
  }

  void navigateToNextScreen() {
    var user = FirebaseAuth.instance.currentUser;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => isOnline
            ? (user == null ? LoginScreen() : HomeScreen())
            : OfflineScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: GestureDetector(
        onTap: () {
          resetUserActivityTimer();
          navigateToNextScreen();
        },
        child: Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            height: 150,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userActivityTimer.cancel();
    super.dispose();
  }
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 100,
              color: Colors.red,
            ),
            Text(
              'You are offline',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
