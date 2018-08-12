import 'dart:async';
import 'package:innova_service_flutter_project/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/model/user.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  String welcome;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _message = '';

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
                    child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                      key: this._loginFormKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  controller: _emailController,
                                  validator: validateEmail,
                                  keyboardType: TextInputType
                                      .emailAddress, // Use email input type for emails.
                                  decoration: new InputDecoration(
                                      icon: Icon(Icons.person),
                                      hintText: 'you@example.com',
                                      labelText: 'E-mail Address')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new TextFormField(
                                  controller: _passwordController,
                                  validator: validatePassword,
                                  obscureText:
                                      true, // Use secure text for passwords.
                                  decoration: new InputDecoration(
                                      icon: Icon(Icons.lock),
                                      helperText:
                                          'deve essere compresa tra gli 8 e 20 caratteri e includere almeno 1 lettera minuscola , 1 maiuscola , 1 numero e 1 carattere speciale ',
                                      hintText: 'Password',
                                      labelText: 'Enter your password')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 60.0, vertical: 20.0),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    if (_loginFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                                      _loginFormKey.currentState.save();
                                      setState(() {
                                        _loginWithEmailAndPassword(
                                            _emailController.text,
                                            _passwordController.text);
                                      });
                                    }
                                  },
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 60.0, vertical: 20.0),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    if (_loginFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                                      _loginFormKey.currentState.save();
                                      setState(() {
                                        _addUserWithEmailAndPassword(
                                            _emailController.text,
                                            _passwordController.text);
                                      });
                                    }
                                  },
                                  child: Text(
                                    'ADD',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 60.0, vertical: 20.0),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    setState(() {
                                      _authenticateWithGoogle();
                                    });
                                  },
                                  child: Text(
                                    'google',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 60.0, vertical: 20.0),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    setState(() {
                                      _signOut();
                                    });
                                  },
                                  child: Text(
                                    'LOGOUT',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: Text(
                                '${_message}',
                                softWrap: true,
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.5,
                              ),
                            ),
                          ])),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _authenticateWithGoogle() async {

    GoogleSignInAccount googleCurrentUser = googleSignIn.currentUser;
    if (googleCurrentUser == null) {
      // Force the user to interactively sign in
      googleCurrentUser = await googleSignIn.signIn();
    }

    final GoogleSignInAuthentication googleAuth =
        await googleCurrentUser.authentication;

    fireUser = await fireAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User user = User.instance(fireUser);
    setState(() {
      currentUser = user;
      currentUser.logged = true;
      _message = 'questo è un nuovo utente Google ${currentUser.email}';
    });
  }

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

  Future<Null> _signOut() async {
    if (googleSignIn != null) {
      await googleSignIn.signOut();
    }
    if (currentUser != null) {
      await fireAuth.signOut();
    }
    setState(() {
      currentUser = null;
      currentUser.logged = false;

      _message = 'user ${currentUser.email}';
    });
  }
}
