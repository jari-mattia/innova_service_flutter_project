import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/data_controller/form_company.dart';
import 'package:innova_service_flutter_project/data_controller/form_private.dart';

class QuoteRequest extends StatefulWidget {
  @override
  QuoteRequestState createState() => new QuoteRequestState();
}

/* this class is a wrapper for forms
*  it provide a radio button to select the form type
* */
class QuoteRequestState extends State<QuoteRequest> {

  // a default value of radio button
  String _groupValue = 'azienda';

  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("Richiedi un Preventivo"), centerTitle: true),
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
                              });
                            },
                            groupValue: _groupValue,
                            value: 'azienda',
                          ),
                          const Text('azienda'),
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
                          const Text('privato'),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: _groupValue == 'azienda' ? FormCompany() : FormPrivate(),
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
