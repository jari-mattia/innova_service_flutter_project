import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/form_section.dart';

class Preventivo extends StatefulWidget {
  @override
  _PreventivoState createState() => new _PreventivoState();
}

class _PreventivoState extends State<Preventivo> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset('asset/images/intervento_bg.png', fit: BoxFit.cover),
            Card(
              color: Color(0xCCFFFFFF),
              margin:
              EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0, top: 30.0),
              child: FormSection(),
            ),
          ],
        ));
  }
}
