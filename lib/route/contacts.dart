import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';
import 'package:innova_service_flutter_project/main.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => new _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Contatti"),
          centerTitle: true,
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Container(
                color: Colors.blue,
                child: Card(
                    margin: EdgeInsets.only(
                        bottom: 10.0, left: 10.0, right: 10.0, top: 30.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              contactUs('tel:$phoneNumber', context);
                            },
                            leading: Image.asset('asset/images/phone.png',
                                width: 50.0),
                            title: Text(
                              "Chiamaci",
                            ),
                            subtitle: Text("$phoneNumber",
                                style: TextStyle(color: Color(0xFFCCCCCC))),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              contactUs('mailto:$emailAddress', context);
                            },
                            leading: Image.asset('asset/images/letter.png',
                                width: 50.0),
                            title: Text(
                              "Email",
                            ),
                            subtitle: Text("$emailAddress",
                                style: TextStyle(color: Color(0xFFCCCCCC))),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              whatsAppOpen(context);
                            },
                            leading: Image.asset('asset/images/whatsapp.png',
                                width: 50.0),
                            title: Text(
                              "Whatsapp",
                            ),
                            subtitle: Text("chattiamo",
                                style: TextStyle(color: Color(0xFFCCCCCC))),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              contactUs('$facebook', context);
                            },
                            leading: Image.asset('asset/images/facebook.png',
                                width: 50.0),
                            title: Text(
                              "Facebook",
                            ),
                            subtitle: Text("seguici !",
                                style: TextStyle(color: Color(0xFFCCCCCC))),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              contactUs('$www', context);
                            },
                            leading: Image.asset('asset/images/worldwide.png',
                                width: 50.0),
                            title: Text(
                              "$www",
                            ),
                            subtitle: Text("visita il nostro sito",
                                style: TextStyle(color: Color(0xFFCCCCCC))),
                          ),
                        ],
                      ),
                    )));
          } else {
            return Container(
                color: Colors.blue,
                child: ListView(children: <Widget>[
                  Card(
                      margin: EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0, top: 30.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                contactUs('tel:$phoneNumber', context);
                              },
                              leading: Image.asset('asset/images/phone.png',
                                  width: 50.0),
                              title: Text(
                                "Chiamaci",
                              ),
                              subtitle: Text("$phoneNumber",
                                  style: TextStyle(color: Color(0xFFCCCCCC))),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                contactUs('mailto:$emailAddress', context);
                              },
                              leading: Image.asset('asset/images/letter.png',
                                  width: 50.0),
                              title: Text(
                                "Email",
                              ),
                              subtitle: Text("$emailAddress",
                                  style: TextStyle(color: Color(0xFFCCCCCC))),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                whatsAppOpen(context);
                              },
                              leading: Image.asset('asset/images/whatsapp.png',
                                  width: 50.0),
                              title: Text(
                                "Whatsapp",
                              ),
                              subtitle: Text("chattiamo",
                                  style: TextStyle(color: Color(0xFFCCCCCC))),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                contactUs('$facebook', context);
                              },
                              leading: Image.asset('asset/images/facebook.png',
                                  width: 50.0),
                              title: Text(
                                "Facebook",
                              ),
                              subtitle: Text("seguici !",
                                  style: TextStyle(color: Color(0xFFCCCCCC))),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                contactUs('$www', context);
                              },
                              leading: Image.asset('asset/images/worldwide.png',
                                  width: 50.0),
                              title: Text(
                                "$www",
                              ),
                              subtitle: Text("visita il nostro sito",
                                  style: TextStyle(color: Color(0xFFCCCCCC))),
                            )
                          ],
                        ),
                      ))
                ]));
          }
        }));
  }
}
