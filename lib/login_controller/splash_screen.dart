import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/model/user.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({this.app});
  final FirebaseApp app;
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();

  }

  // the starting point of App.. call a timer , try for login and routes to home
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  // try for silently login then routes to home
  void navigationPage() async{
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
    else {
      if (googleCurrentUser == null)
        _authenticateWithGoogleSilently().then((fireUser) =>
        (fireUser == null)
            ? Navigator.of(context).pushReplacementNamed('/home')
            : User
            .instance(fireUser)
            .then((user) => currentUser = user)
            .whenComplete(() =>
            Navigator.of(context).pushReplacementNamed('/home')));
    }
  }

  // silently login
  Future<FirebaseUser> _authenticateWithGoogleSilently() async {
    if (googleCurrentUser == null) {
      googleCurrentUser = await googleSignIn.signInSilently();
    }
    if (googleCurrentUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;

      fireUser = await fireAuth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      assert(fireUser.email != null);
      assert(fireUser.displayName != null);
      assert(!fireUser.isAnonymous);
      assert(await fireUser.getIdToken() != null);
      return fireUser;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body : Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.blue),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 90.0,
                            child:  Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image.asset(
                                'asset/images/logo.png',
                                width: 130.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        Text(
                          'loading',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
      ),
    );
  }
}


