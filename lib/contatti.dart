import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/bottom_modal_sheet.dart';

class Contatti extends StatefulWidget {
  @override
  _ContattiState createState() => new _ContattiState();
}

class _ContattiState extends State<Contatti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
    appBar: AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    title: Text("Contatti"),centerTitle: true,),
    body:OrientationBuilder(builder: (context, orientation) {
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
                          contactUs('tel:+393391418005');
                        },
                        leading:
                            Image.asset('asset/images/phone.png', width: 50.0),
                        title: Text(
                          "Chiamaci",
                        ),
                        subtitle: Text("3391418005",
                            style: TextStyle(color: Color(0xFFCCCCCC))),
                      ),
                      Divider(),
                      ListTile(
                          onTap: () {
                            contactUs('mailto:info@innovaservice.eu');
                          },
                        leading:
                            Image.asset('asset/images/letter.png', width: 50.0),
                        title: Text(
                          "Email",
                        ),
                        subtitle: Text("info@innovaservice.eu",
                            style: TextStyle(color: Color(0xFFCCCCCC))),
                      ),
                      Divider(),
                      ListTile(
                          onTap: () {
                            whatsAppOpen();
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
                          contactUs('http://www.facebook.com');
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
                          contactUs('http://innovaservice.eu/');
                        },
                        leading: Image.asset('asset/images/worldwide.png',
                            width: 50.0),
                        title: Text(
                          "www.innovaservice.eu",
                        ),
                        subtitle: Text("visita il nostro sito",
                            style: TextStyle(color: Color(0xFFCCCCCC))),
                      ),
                    ],
                  ),
                )));
      } else {
        return
            Container(
                color: Colors.blue,
                child:ListView(

                      children: <Widget>[
                        Card(
                margin: EdgeInsets.only(
                bottom: 10.0, left: 10.0, right: 10.0, top: 30.0),
                       child : Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                            ListTile(
                              onTap: () {
                                contactUs('tel:+393391418005');
                              },
                              leading: Image.asset('asset/images/phone.png',
                                  width: 50.0),
                              title: Text(
                                "Chiamaci",
                              ),
                              subtitle: Text("3391418005",
                                  style: TextStyle(color: Color(0xFFCCCCCC))),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                contactUs('mailto:info@innovaservice.eu');
                              },
                              leading: Image.asset('asset/images/letter.png',
                                  width: 50.0),
                              title: Text(
                                "Email",
                              ),
                              subtitle: Text("info@innovaservice.eu",
                                  style: TextStyle(color: Color(0xFFCCCCCC))),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                whatsAppOpen();
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
                                contactUs('http://www.facebook.com');
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
                                contactUs('http://innovaservice.eu/');
                              },
                              leading: Image.asset('asset/images/worldwide.png',
                                  width: 50.0),
                              title: Text(
                                "www.innovaservice.eu",
                              ),
                              subtitle: Text("visita il nostro sito",
                                  style: TextStyle(color: Color(0xFFCCCCCC))),
                            )

                        ],
                      ),
                    ))]));
      }}));
  }
}
