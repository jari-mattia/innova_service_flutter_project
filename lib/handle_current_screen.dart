import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innova_service_flutter_project/home_page.dart';
import 'package:innova_service_flutter_project/login_test.dart';
import 'package:innova_service_flutter_project/splash_screen.dart';


class HandleScreen extends StatefulWidget {
  @override
  _HandleScreenState createState() => new _HandleScreenState();
}

class _HandleScreenState extends State<HandleScreen> {
  @override
  Widget build(BuildContext context) {

    return _handleCurrentScreen();

  }

}

Widget _handleCurrentScreen() {
  return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new SplashScreen();
        } else {
          if (snapshot.hasData) {
            return new MyHomePage();
          }
          return new Login();
        }
      }
  );
}