import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/form_azienda.dart';
import 'package:innova_service_flutter_project/form_privato.dart';

class Preventivo extends StatefulWidget {
  @override
  _PreventivoState createState() => new _PreventivoState();
}

class _PreventivoState extends State<Preventivo> {
  var _groupValue = 'azienda';

  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text("Richiedi un Preventivo"), centerTitle: true),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(color: Theme.of(context).primaryColor),
            SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Radio(
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value;
                                print(_groupValue);
                              });
                            },
                            groupValue: _groupValue,
                            value: 'azienda',
                          ),
                          Text('azienda'),
                          Radio(
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value;
                                print(_groupValue);
                              });
                            },
                            groupValue: _groupValue,
                            value: 'privato',
                          ),
                          Text('privato'),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: _groupValue == 'azienda' ? FormAzienda() : FormPrivato(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
