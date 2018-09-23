import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/data_controller/quote.dart';
import 'package:innova_service_flutter_project/login_controller/login.dart';
import 'package:innova_service_flutter_project/main.dart';

class MyServicesPage extends StatefulWidget {
  MyServicesPage(
      Key key, this._av, this._bg, this._title, this._desc, this._color, this._arrow)
      : super(key: key);
  final String _av;
  final String _bg;
  final String _title;
  final String _desc;
  final Color _color;
  final Widget _arrow;

  @override
  _MyServicesPageState createState() => new _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return Scaffold(
          backgroundColor: widget._color,
          appBar: AppBar(
            backgroundColor: widget._color,
            title: Text("Servizi"),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                key: Key("page_bg"),
                foregroundDecoration: BoxDecoration(color: Color(0x22000000)),
                child: Image.asset(
                  "asset/images/${widget._bg}",
                  alignment: Alignment.topCenter,
                ),
              ),
              ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 180.0),
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          margin: EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                          elevation: 6.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30.0,
                                    top: 120.0,
                                    right: 30.0,
                                    bottom: 40.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        "${widget._title}",
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.4,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Text(
                                      "${widget._desc}",
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 40.0),
                                      child: RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 60.0),
                                        color: widget._color,
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 100.0),
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 85.0,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 105.0),
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("asset/images/${widget._av}"),
                              radius: 80.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              widget._arrow,
            ],
          ),
        );
      } else
        return Scaffold(
          backgroundColor: widget._color,
          appBar: AppBar(
              backgroundColor: widget._color, title: Text("Innova Service")),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                key: Key("page_bg"),
                foregroundDecoration: BoxDecoration(color: Color(0x22000000)),
                child: Image.asset(
                  "asset/images/${widget._bg}",
                  fit: BoxFit.cover,
                ),
              ),
              ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 180.0),
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          margin: EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                          elevation: 6.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30.0,
                                    top: 120.0,
                                    right: 30.0,
                                    bottom: 40.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        "${widget._title}",
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.4,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Text(
                                      "${widget._desc}",
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 40.0),
                                      child: RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 200.0),
                                        color: widget._color,
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 100.0),
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 85.0,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 105.0),
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("asset/images/${widget._av}"),
                              radius: 80.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              widget._arrow,
            ],
          ),
        );
    });
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog
        return AlertDialog(
          content : new Text("Devi accedere per proseguire"),
          actions : <Widget>[
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
}
