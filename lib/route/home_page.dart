import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/data_controller/send_image.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:innova_service_flutter_project/data_controller/intervention.dart';
import 'package:innova_service_flutter_project/login_controller/login_test.dart';
import 'package:innova_service_flutter_project/data_controller/quote.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';
import 'package:innova_service_flutter_project/model/user.dart';

/*
*
* Home Page
*
* */
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeScaffold();
  }
}

class WelcomeText extends StatefulWidget {
  @override
  _WelcomeTextState createState() => _WelcomeTextState();
}

class _WelcomeTextState extends State<WelcomeText> {
  String welcome;

  @override
  initState() {
    (currentUser != null) ? welcome = '${currentUser.name}' : welcome = '';
    super.initState();
  }

  /*
 *  Logout
 */
  Future<void> _signOut() async {
    await User
        .signOut(currentUser)
        .then((user) => setState(() => currentUser = user));
    if (fireUser != null) await fireAuth.signOut();
    if (googleCurrentUser != null) await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser != null) {
      setState(() {
        welcome = '${currentUser.name}';
      });
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 3.0),
              child: Icon(Icons.person_outline,
                  color: Theme.of(context).accentColor)),
          Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 3.0),
              child: Text(
                'Salve ',
                textAlign: TextAlign.end,
              )),
          Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 3.0),
              child: Text(
                welcome,
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
          Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 3.0),
              child: OutlineButton(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                textColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  await _signOut();
                },
                child: Text(
                  'Logout ',
                  textAlign: TextAlign.end,
                ),
              ))
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 3.0),
              child: OutlineButton(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text(
                  'Login',
                  textAlign: TextAlign.end,
                ),
              ))
        ],
      );
    }
  }
}

class HomeScaffold extends StatefulWidget {
  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  /*
 *
 *        AlertDialog
 *
 * */
  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Devi accedere per proseguire"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ACCEDI",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _portraitPage() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset('asset/images/home_bg.png', fit: BoxFit.cover),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Card(
                color: Color(0xDDFFFFFF),
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: 15.0, left: 30.0, right: 30.0, top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(child: WelcomeText()),
                      Divider(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Image.asset(
                          'asset/images/logo.png',
                          width: 15.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: Text(
                          "Facility Management \n a servizio di imprese e cittadini",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.2,
                        ),
                      ),

                      // Intervento button
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Intervention()),
                              ),
                          child: Text("RICHIEDI INTERVENTO"),
                          textColor: Colors.white,
                        ),
                      ),

                      // Preventivo Button
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            (currentUser != null)
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuoteRequest()),
                                  )
                                : _showDialog(context);
                          },
                          child: Text("FAI UN PREVENTIVO"),
                          textColor: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text.rich(TextSpan(
                                style: TextStyle(fontSize: 12.0),
                                text: "INVIACI")),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: FloatingActionButton(
                                  onPressed: () {
                                    (currentUser != null)
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SendImage()))
                                        : _showDialog(context);
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black54,
                                )),
                            Text.rich(TextSpan(
                                style: TextStyle(fontSize: 12.0),
                                text: "UNA FOTO"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
      ],
    );
  }

  Widget _horizontalPage() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset('asset/images/home_bg.png', fit: BoxFit.cover),
        SingleChildScrollView(
          child: Card(
            color: Color(0xCCFFFFFF),
            margin: EdgeInsets.only(
                top: 20.0, bottom: 15.0, left: 15.0, right: 15.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: WelcomeText(),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Image.asset(
                                'asset/images/logo.png',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Text(
                                "Facility Management \n a servizio di imprese e cittadini",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.1,
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Intervention()),
                                  );
                                },
                                child: Text("RICHIEDI INTERVENTO"),
                                textColor: Colors.white,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  (currentUser != null)
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  QuoteRequest()),
                                        )
                                      : _showDialog(context);
                                },
                                child: Text("FAI UN PREVENTIVO"),
                                textColor: Colors.white,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text.rich(TextSpan(
                                      style: TextStyle(fontSize: 12.0),
                                      text: "INVIACI UNA FOTO")),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          (currentUser != null)
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SendImage()))
                                              : _showDialog(context);
                                        },
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Colors.black54,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _scaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Innova Service'),
        centerTitle: true,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _portraitPage();
        } else {
          return _horizontalPage();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }
}
