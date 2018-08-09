import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormCompany extends StatefulWidget {
  @override
  FormCompanyState createState() {
    return FormCompanyState();
  }
}

class _CompanyData {
  static String clientType = 'azienda';
  String nome = '';
  String email = '';
  String pIva = '';
  String request = '';
  String service = '';
}

class FormCompanyState extends State<FormCompany> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  _CompanyData _data = new _CompanyData();

  List _categories = [
    "Pulizie ",
    "Aree Verdi",
    "Impianti",
    "Disinfestazioni",
    "Edilizia"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCat;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCat = null;
    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String _category in _categories) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(
          new DropdownMenuItem(value: _category, child: new Text(_category)));
    }
    return items;
  }

  void changedDropDownItem(String selectedCat) {
    print("Selected city $selectedCat, we are going to refresh the UI");
    setState(() {
      _currentCat = selectedCat;
      _data.service = selectedCat;
    });
  }

  bool _autoValidate = false;

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();

      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentReference document =
            Firestore.instance.document('richieste/privato');
        await document
            .collection('${_data.pIva}')
            .document('${DateTime.now().toUtc().toString()}')
            .setData(<String, String>{
              'nome': _data.nome,
              'email': _data.email,
              'partita iva': _data.pIva,
              'servizio': _data.service,
              'richiesta': _data.request
            })
            .whenComplete(() => Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("""Grazie per averci inviato la richiesta \nTi ricontatteremo al più presto """),
                  duration: Duration(seconds: 4),
                )))
            .whenComplete(resetForm)
            .catchError((e) => print(e));
      });
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String _sanitizeTextField(String value) {
    if (value.isNotEmpty) value = value.trim().toLowerCase();
    return value;
  }

  String _sanitizePIva(String value) {
    if (value.isNotEmpty) value = value.trim();
    return value;
  }

  String validateNome(String value) {
    if (value.length < 3)
      return 'il nome deve contenere almeno 3 caratteri';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'inserisci un email valida';
    else
      return null;
  }

  String validatePIva(String value) {
    Pattern pattern = r'^[0-9]{11}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'inserisci una partita iva valida';
    else
      return null;
  }

  String validateRequest(String value) {
    if (value.isEmpty)
      return 'inserisci la richiesta ';
    else
      return null;
  }

  void _resetForm() {
    _formKey.currentState.reset();
    setState(() {
      _autoValidate = false;
      _currentCat = null;
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
                              value: _currentCat,
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
                      value = _sanitizeTextField(value);
                      this._data.nome = value;
                    },
                    onFieldSubmitted: validateNome,
                    maxLength: 24,
                    decoration: InputDecoration(
                        labelText: 'Nome', icon: Icon(Icons.group)),
                    validator: validateNome,
                  ), // We'll build this out in the next steps!

                  TextFormField(
                      onSaved: (String value) {
                        value = _sanitizePIva(value);
                        this._data.pIva = value;
                      },
                      maxLength: 11,
                      decoration: InputDecoration(
                          labelText: 'Partita Iva', icon: Icon(Icons.payment)),
                      keyboardType: TextInputType.number,
                      validator: validatePIva), // We'l

                  TextFormField(
                      onSaved: (String value) {
                        value = _sanitizeTextField(value);
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
                          color: Theme.of(context).primaryColor,
                          onPressed: _validateInputs,
                          child: Text('INVIA',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: RaisedButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 50.0),
                            color: Colors.redAccent,
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
