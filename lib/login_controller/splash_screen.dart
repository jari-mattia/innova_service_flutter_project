import 'dart:async';
import 'package:innova_service_flutter_project/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/login_controller/login_test.dart';
import 'package:innova_service_flutter_project/route/router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),
        () => handleCurrentPage() //InterventionRequest()),
        );
  }

  void handleCurrentPage() {
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account)  async{
      setState(() {
        googleSignIn.currentUser == account;
      });
      //Logged with Google
      if (googleSignIn.currentUser != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Router()) //InterventionRequest()),
              );
      }
    });
    //try silently log with google
    googleSignIn.signInSilently();
    //if log succeed
    if (googleSignIn.currentUser != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Router()) //InterventionRequest()),
            );
    }
    //check for firebase user

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

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
