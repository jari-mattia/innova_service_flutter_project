import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/form_azienda.dart';

class Intervento extends StatefulWidget {
  @override
  _InterventoState createState() => new _InterventoState();
}

class _InterventoState extends State<Intervento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset('asset/images/preventivo_bg.png', fit: BoxFit.cover),
        Card(
          color: Color(0xCCFFFFFF),
          margin:
              EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0, top: 30.0),
          child: FormAzienda(),
        ),
      ],
    ));
  }
}
