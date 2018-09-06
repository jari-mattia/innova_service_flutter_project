import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/login_controller/splash_screen.dart';
import 'package:innova_service_flutter_project/model/user.dart';
import 'package:innova_service_flutter_project/route/router.dart';

final String emailAddress = 'yari.mattia.jobs@gmail.com';
//final String emailAddress = 'clienti@innovaservice.eu';
//final String phoneNumber = '+393391418005';
final String phoneNumber = '+393755070555';
final String facebook = 'https://www.facebook.com/InnovaService.eu/';
final String www = 'http://innovaservice.eu';

User currentUser;
final FirebaseAuth fireAuth = FirebaseAuth.instance;
FirebaseUser fireUser;
final GoogleSignIn googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'https://www.googleapis.com/auth/gmail.send',
    'https://www.googleapis.com/auth/gmail.compose',
    'https://www.googleapis.com/auth/devstorage.read_write'

],);
GoogleSignInAccount googleCurrentUser;
int requests = 0;



void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: new FirebaseOptions(

      googleAppID: Platform.isIOS
          ? '1:775439105293:ios:65e3497b0149dc6f'
          : '1:775439105293:android:65e3497b0149dc6f',
      gcmSenderID: '775439105293',
      apiKey: 'AIzaSyAl2x50e6_ESCptmHdWWBDaNpKhuhS5-u4',
      projectID: 'innova-servicve',
    ),
  );
runApp(new MyApp(app: app));
}
class MyApp extends StatefulWidget {
  MyApp({this.app});
  final FirebaseApp app;
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
      home: SplashScreen(app: widget.app),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Router(app: widget.app)
      },//HandleCurrentScreen()
    );
  }
}
