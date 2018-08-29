import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/common_doc/privacy_policy.dart';
import 'package:innova_service_flutter_project/model/user.dart';
import 'package:innova_service_flutter_project/route/router.dart';
import 'package:innova_service_flutter_project/main.dart';

/*
*
*     Login Page
*
*/
class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  bool privacyConsent;
  bool enableUnCheckedPrivacy;

  @override
  initState() {
    privacyConsent = false;
    enableUnCheckedPrivacy = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('LogIn'),
        actions: <Widget>[],
      ),
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
                                        setState(() {
                                          enableUnCheckedPrivacy = true;
                                        });
                                        if (privacyConsent == true) {
                                          _authenticateWithGoogle()
                                              .then((fireUser) =>
                                                  createUserFromFireUser(
                                                      fireUser))
                                              .then((user) {
                                            setState(() {
                                              currentUser = user;
                                              currentUser.logged = true;
                                              currentUser.add();
                                            });
                                          }).whenComplete(() => Navigator.pop(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Router())));
                                        }
                                      },
                                      child: Text(
                                        'ACCEDI',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                              ]),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: <Widget>[
                                UnCheckedPrivacyText(
                                    privacyConsent, enableUnCheckedPrivacy)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset('asset/images/logo.png',
                                width: 80.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CheckboxListTile(
                              subtitle:
                                  Text('ai sensi del Regolamento UE 2016/679'),
                              onChanged: (bool value) {
                                setState(() => privacyConsent = value);
                                print(privacyConsent);
                              },
                              value: privacyConsent,
                              title: Text.rich(TextSpan(
                                text:
                                    'Ho letto e Acconsento al Trattamento dei dati personali',
                                style: new TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14.0,
                                    decoration: TextDecoration.underline),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicy()));
                                  },
                              )),
                            ),
                          ),
                        ]),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  //FUNCTIONS
  /*
  *   Google Auth
  */
  Future<FirebaseUser> _authenticateWithGoogle() async {
    GoogleSignInAccount googleUser;

    if (googleUser == null) {
      googleUser = await googleSignIn.signInSilently();
    }
    if (googleUser == null) {
      googleUser = await googleSignIn.signIn();
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

  /*
  *   Create User
  */
  Future<User> createUserFromFireUser(FirebaseUser fireUser) async {
    User user = await User.instance(fireUser);
    assert(user != null);
    return user;
  }
}

/*
*
*     Privacy Police Checkbox Class
*
*/
class UnCheckedPrivacyText extends StatelessWidget {
  final bool check;
  final bool enable;

  final String _blankMessage = '';
  final String _alertMessage =
      'devi acconsentire \nai dati personali per continuare';
  UnCheckedPrivacyText(this.check, this.enable);

  @override
  Widget build(BuildContext context) {
    if (enable)
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text.rich(TextSpan(
                text: _textControl(check),
                style: TextStyle(color: Colors.redAccent)))
          ],
        ),
      );
    else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[Text('')],
        ),
      );
    }
  }

  String _textControl(bool check) {
    return (check == true) ? _blankMessage : _alertMessage;
  }
}
