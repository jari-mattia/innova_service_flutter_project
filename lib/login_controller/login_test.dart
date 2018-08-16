import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/model/user.dart';
import 'package:innova_service_flutter_project/login_controller/splash_screen.dart';
import 'package:innova_service_flutter_project/route/router.dart';
import 'package:innova_service_flutter_project/main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
//FUNCTIONS

  Future<FirebaseUser> _authenticateWithGoogle() async {
    GoogleSignInAccount googleUser;
    if (googleUser == null) {
      googleUser = await googleSignIn.signInSilently();
    }
    if (googleUser == null) {
      try {
        googleUser = await googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
    }
    setState(() {
      googleCurrentUser = googleUser;
    });
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

  Future<User> createUserFromFirebaseUser(FirebaseUser fireUser) async {
    User user = await User.instance(fireUser);
    assert(user != null);
    return user;
  }

  Future<Null> _signOut() async {
    if (currentUser != null) await currentUser.signOut();
    if (fireUser != null) await fireAuth.signOut();
    if (googleCurrentUser != null) await googleSignIn.signOut();
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
            child: SingleChildScrollView(
              child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
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
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 60.0, vertical: 20.0),
                                      color: Theme.of(context).accentColor,
                                      onPressed: () {
                                        _authenticateWithGoogle()
                                            .then((fireUser) =>
                                                createUserFromFirebaseUser(
                                                    fireUser))
                                            .then((user) {
                                          currentUser = user;
                                          currentUser.logged = true;
                                        }).whenComplete(() => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Router())));
                                      },
                                      child: Text(
                                        'ACCEDI',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 60.0, vertical: 20.0),
                                      color: Colors.black54,
                                      onPressed: () {
                                        _signOut().whenComplete(() => new Router());
                                        },

                                      child: Text(
                                        'ESCI',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ))
                              ]),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset('asset/images/logo.png',
                                width: 80.0),
                          ),
                        ]),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
