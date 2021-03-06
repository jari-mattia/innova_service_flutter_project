import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';
import 'package:innova_service_flutter_project/main.dart';

class Intervention extends StatefulWidget {
  @override
  _InterventionState createState() => new _InterventionState();
}

class _InterventionState extends State<Intervention> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Richiedi Intervento"),
          centerTitle: true,
        ),
        body: OrientationBuilder(builder: (context, orientation) {
            return Container(
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Card(
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0,),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Divider(),
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
                                  whatsAppOpenIos(context);
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
                                  contactUs('sms:$phoneNumber', context);
                                },
                                leading: Image.asset('asset/images/sms.png',
                                    width: 50.0),
                                title: Text(
                                  "Sms",
                                ),
                                subtitle: Text("inviaci un sms",
                                    style: TextStyle(color: Color(0xFFCCCCCC))),
                              ),
                              Divider(),
                            ],
                          ),
                        )),
                  ],
                ));

        }));
  }
}
