import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/data_controller/send_image.dart';
import 'package:innova_service_flutter_project/login_controller/splash_screen.dart';
import 'package:innova_service_flutter_project/model/user.dart';
import 'package:innova_service_flutter_project/route/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


final String emailAddress = 'clienti@innovaservice.eu';
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

],);
GoogleSignInAccount googleCurrentUser;
int requests = 0;



void main()  {
runApp(new MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('it'),
      ],

      title: 'Innova Service',
      theme: ThemeData(

          fontFamily: 'Montserrat',
          primaryColor: Colors.blue,
          accentColor: Colors.cyan),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Router(),
        '/noImage' : (BuildContext context) => new NoImage()
      },//HandleCurrentScreen()
    );
  }
}
