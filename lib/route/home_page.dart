import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:innova_service_flutter_project/data_controller/intervention.dart';
import 'package:innova_service_flutter_project/login_controller/login_test.dart';
import 'package:innova_service_flutter_project/data_controller/quote.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 String _welcome = '';
  @override
  void initState() {
    if (currentUser != null) {
      _welcome = 'Salve , ${currentUser.name}';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset('asset/images/home_bg.png', fit: BoxFit.cover),
              SingleChildScrollView(
                child: Card(
                  color: Color(0xDDFFFFFF),
                  margin: EdgeInsets.only(top: 6.0, left: 15.0, right: 15.0),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 15.0, left: 30.0, right: 30.0, top: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text('${_welcome}',textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w500),)
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16.0),
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Image.asset('asset/images/logo.png',width: 20.0,),

                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 12.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Text(
                            "Facility Management \n a servizio di imprese e cittadini",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.5,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()) //InterventionRequest()),
                              );
                            },
                            child: Text("RICHIEDI INTERVENTO"),
                            textColor: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuoteRequest()),
                              );
                            },
                            child: Text("FAI UN PREVENTIVO"),
                            textColor: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children : <Widget>[
                              Text.rich(TextSpan(style: TextStyle(fontSize: 12.0),text:"INVIACI")),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  child: FloatingActionButton(
                                    onPressed:() => getImage(context),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color:Colors.white,
                                    ),
                                    backgroundColor: Colors.black54,
                                  )),
                              Text.rich(TextSpan(style: TextStyle(fontSize: 12.0),text:"UNA FOTO"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset('asset/images/home_bg.png', fit: BoxFit.cover),
              SingleChildScrollView(
                child : Card(
                  color: Color(0xCCFFFFFF),
                  margin: EdgeInsets.only(top: 20.0,bottom: 15.0, left: 15.0, right: 15.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                    child: Row(children: <Widget>[
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
                              Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text('${_welcome}',textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w500),)
                              ),
                              Divider(),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InterventionRequest()),
                                    );
                                  },
                                  child: Text("RICHIEDI INTERVENTO"),
                                  textColor: Colors.white,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QuoteRequest()),
                                    );
                                  },
                                  child: Text("FAI UN PREVENTIVO"),
                                  textColor: Colors.white,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children : <Widget>[
                                    Text.rich(TextSpan(style: TextStyle(fontSize: 12.0),text:"INVIACI UNA FOTO")),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    child: FloatingActionButton(
                                      onPressed:() => getImage(context),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color:Colors.white,
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
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}