import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';


class FormPrivate extends StatefulWidget {
  @override
  FormPrivateState createState() {
    return FormPrivateState();
  }
}

class _DataPrivate {
  static String clientType = 'privato';
  String firstName = '';
  String lastName = '';
  String email = '';
  String fiscalCode = '';
  String request = '';
  String service = '';
}

class FormPrivateState extends State<FormPrivate> {

  final _formKey = GlobalKey<FormState>();
  _DataPrivate _data = new _DataPrivate();
  bool _autoValidate = false;
  String _currentService;
  List<String> _items = [
    "Pulizie ",
    "Aree Verdi",
    "Impianti",
    "Disinfestazioni",
    "Edilizia"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems(_items);
    _currentService = null;
    super.initState();
  }

  void changedDropDownItem(String selectedCat) {
    setState(() {
      _currentService = selectedCat;
      _data.service = selectedCat;
    });
  }


  void onSubmitData() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();

      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentReference document =
            Firestore.instance.document('richieste/privato');
        await document
            .collection('${_data.fiscalCode}')
            .document('${DateTime.now().toUtc().toString()}')
            .setData(<String, String>{
              'nome': _data.firstName,
              'cognome': _data.lastName,
              'email': _data.email,
              'codice_fiscale': _data.fiscalCode,
              'servizio': _data.service,
              'richiesta': _data.request
            })
            .whenComplete(() => Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("""Grazie per averci inviato la richiesta \nTi ricontatteremo al più presto """),
                  duration: Duration(seconds: 4),
                )))
            .whenComplete(_resetForm)
            .catchError((e) => print(e));
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState.reset();
    setState(() {
      _autoValidate = false;
      _currentService = null;
    });
  }

  Future<void> resetForm() async {
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return SafeArea(
      bottom: false,
      top: false,
      child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        InputDecorator(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.list),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text('Scegli tra i servizi'),
                              value: _currentService,
                              items: _dropDownMenuItems,
                              onChanged: changedDropDownItem,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    onSaved: (String value) {
                      value = sanitizeTextField(value);
                      this._data.firstName = value;
                    },
                    onFieldSubmitted: validateFirstName,
                    maxLength: 24,
                    decoration: InputDecoration(
                        labelText: 'Nome', icon: Icon(Icons.person)),
                    validator: validateFirstName,
                  ), // We'll build this out in the next steps!

                  TextFormField(
                    onSaved: (String value) {
                      value = sanitizeTextField(value);
                      this._data.lastName = value;
                    },
                    onFieldSubmitted: validateLastName,
                    maxLength: 24,
                    decoration: InputDecoration(
                        labelText: 'Cognome', icon: Icon(Icons.person_outline)),
                    validator: validateLastName,
                  ), // We'll build t

                  TextFormField(
                      onSaved: (String value) {
                        value = sanitizeFiscalCode(value);
                        this._data.fiscalCode = value;
                      },
                      maxLength: 16,
                      decoration: InputDecoration(
                          labelText: 'Codice Fiscale',
                          icon: Icon(Icons.payment)),
                      validator: validateFiscalCode), // We'l

                  TextFormField(
                      onSaved: (String value) {
                        value = sanitizeTextField(value);
                        this._data.email = value;
                      },
                      maxLength: 256,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail), // We'

                  TextFormField(
                    onSaved: (String value) {
                      this._data.request = value;
                    },
                    maxLength: 1000,
                    decoration: InputDecoration(
                        labelText: 'Richiesta', icon: Icon(Icons.edit)),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: validateRequest,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 50.0),
                          color: Theme.of(context).accentColor,
                          onPressed: onSubmitData,
                          child: Text('INVIA',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: RaisedButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 50.0),
                            color: Colors.black54,
                            onPressed: _resetForm,
                            child: Text('RESET',
                                style: TextStyle(color: Colors.white)),
                          )),
                    ],
                  )
                ]),
          )),
    );
  }
}
