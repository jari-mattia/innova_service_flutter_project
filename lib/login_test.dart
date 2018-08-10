import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {

  static String name = '';


}

class Login extends StatefulWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('LogIn')),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  onPressed: _authenticateWithGoogle,
                  child: Text('login con Google')),
              Divider(),
              Text('Ciao ${User.name}')
            ],
          ),
        ),
      ),
    );
  }

  void _authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await widget.firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(user.displayName);
    User.name = user.displayName;
  }
}
