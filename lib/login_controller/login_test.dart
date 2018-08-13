import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/model/user.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';
import 'package:innova_service_flutter_project/route/router.dart';

User currentUser;
FirebaseAuth fireAuth = FirebaseAuth.instance;
FirebaseUser fireUser;
GoogleSignIn googleSignIn = new GoogleSignIn();
GoogleSignInAccount googleUser;

class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String _message;

  @override
  void initState() {
    _message = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('LogIn')),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: new ListView(
              children: <Widget>[
                Card(
                    margin: EdgeInsets.all(60.0),
                    child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                      key: this._loginFormKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.lock_outline,
                              size: 50.0,
                              color: Colors.grey,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 20.0),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                _authenticateWithGoogle()
                                    .then((fireUser) =>
                                        createUserFromFirebaseUser(fireUser))
                                    .then((user) => currentUser = user)
                                    .whenComplete(() => setState(() {
                                          _message =
                                              'questo è un nuovo utente User ${currentUser.email}';
                                        }));
                                /*.whenComplete(() => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Router())));*/
                              },
                              child: Text(
                                'ACCEDI',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 20.0),
                              color: Colors.black54,
                              onPressed: () {
                                _signOut().whenComplete(() => setState(() {
                                      _message = '';
                                    }));
                              },
                              child: Text(
                                'LOGOUT',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child:
                              Image.asset('asset/images/logo.png', width: 80.0),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Text(
                            _message,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ])),
                    ))],
              ),
            ),
          ),
        ),
      );

  }

  Future<FirebaseUser> _authenticateWithGoogle() async {
    GoogleSignInAccount googleUser;
    if (googleUser == null) {
      // Force the user to interactively sign in
      try {
        googleUser = await googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

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

  Future<Null> _signOut() async {
    if (googleUser != null) await googleSignIn.signOut();
    if (fireUser != null) await fireAuth.signOut();
  }
}

Future<User> createUserFromFirebaseUser(FirebaseUser fireUser) async {
  User user = await User.instance(fireUser);
  assert(user != null);
  return user;
}
/*
  Future<Null> _addUserWithEmailAndPassword(
      String email, String password) async {
    fireUser = await fireAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = User.instance(fireUser);
    setState(() {
      currentUser = user;
      currentUser.logged = true;
      _message = 'questo è un nuovo utente ${currentUser.email}';
    });
  }

  Future<Null> _loginWithEmailAndPassword(String email, String password) async {
    fireUser = await fireAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = User.instance(fireUser);
    setState(() {
      currentUser = user;
      currentUser.logged = true;
      _message = 'bentornato ${currentUser.email}';
    });
  }
*/
