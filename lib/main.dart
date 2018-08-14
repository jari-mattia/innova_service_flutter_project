import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/login_controller/login_test.dart';
import 'package:innova_service_flutter_project/login_controller/splash_screen.dart';
import 'package:innova_service_flutter_project/model/user.dart';




void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Innova Service',
      theme: ThemeData(

          fontFamily: 'Montserrat',
          primaryColor: Colors.blue,
          accentColor: Colors.cyan),
      home: Login(),//HandleCurrentScreen()
    );
  }
}
