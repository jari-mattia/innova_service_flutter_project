import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/login_controller/login_test.dart';
import 'package:innova_service_flutter_project/model/user.dart';
import 'package:innova_service_flutter_project/route/router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (googleCurrentUser == null)
      _authenticateWithGoogleSilently().then((fireUser) => (fireUser == null)
          ? Navigator.push(
              context, MaterialPageRoute(builder: (context) => Router()))
          : User
              .instance(fireUser)
              .then((user) => currentUser = user)
              .whenComplete(() => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Router()))));
  }

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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
                        radius: 50.0,
                        child: Icon(
                          Icons.cloud_download,
                          color: Theme.of(context).accentColor,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        'innova',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
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
                      'waiting',
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


