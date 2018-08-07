import 'package:flutter/material.dart';

class FormPrivato extends StatefulWidget {
  @override
  FormPrivatoState createState() {
    return FormPrivatoState();
  }
}

class _DatiPrivato {
  static String tipologia = 'privato';
  String nome = '';
  String cognome = '';
  String email = '';
  String codFisc = '';
  String richiesta = '';
  String cat = '';
}

class FormPrivatoState extends State<FormPrivato> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  _DatiPrivato _dati = new _DatiPrivato();

  List _categorie = [
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
    _currentCat = _dropDownMenuItems[0].value;
    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String _categoria in _categorie) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(
          new DropdownMenuItem(value: _categoria, child: new Text(_categoria)));
    }
    return items;
  }

  void changedDropDownItem(String selectedCat) {
    print("Selected city $selectedCat, we are going to refresh the UI");
    setState(() {
      _currentCat = selectedCat;
      _dati.cat = selectedCat;
    });
  }

  bool _autoValidate = false;

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      print(
          'categoria : ${_dati.cat}, \nnome : ${_dati.nome},\npartita iva : ${_dati.codFisc}, \nemail : ${_dati.email},\nmessaggio : ${_dati.richiesta}\n');
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateNome(String value) {
    if (value.length < 3)
      return 'il nome deve contenere almeno 3 caratteri';
    else
      return null;
  }

  String validateCognome(String value) {
    if (value.length < 3)
      return 'il cognome deve contenere almeno 3 caratteri';
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

  String validateCodFisc(String value) {
    Pattern pattern = r'/^(?:(?:[B-DF-HJ-NP-TV-Z]|[AEIOU])[AEIOU][AEIOUX]|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[1256LMRS][\dLMNP-V])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[1-9MNP-V][\dLMNP-V]|[0L][1-9MNP-V]))[A-Z]$/i';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'inserisci un Codice Fiscale valido';
    else
      return null;
  }

  String validateRichiesta(String value) {
    if (value.isEmpty)
      return 'inserisci la richiesta ';
    else
      return null;
  }

  void _resetForm() {
    _formKey.currentState.reset();
    setState(() {
      _autoValidate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize:MainAxisSize.max ,children: <
              Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Text("Seleziona la tua categoria di interesse: "),
                  DropdownButton(
                    value: _currentCat,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  ),
                ],
              ),
            ),
            TextFormField(
              onSaved: (String value) {
                this._dati.nome = value;
              },
              onFieldSubmitted: validateNome,
              maxLength: 24,
              decoration: InputDecoration(
                  labelText: 'Nome', prefixIcon: Icon(Icons.person)),
              validator: validateNome,
            ), // We'll build this out in the next steps!

            TextFormField(
              onSaved: (String value) {
                this._dati.cognome = value;
              },
              onFieldSubmitted: validateCognome,
              maxLength: 24,
              decoration: InputDecoration(
                  labelText: 'Cognome', prefixIcon: Icon(Icons.person_outline)),
              validator: validateCognome,
            ), // We'll build t

            TextFormField(
                onSaved: (String value) {
                  this._dati.codFisc = value;
                },
                maxLength: 16,
                decoration: InputDecoration(
                    labelText: 'Codice Fiscale', prefixIcon: Icon(Icons.payment)),
                validator: validateCodFisc), // We'l

            TextFormField(
                onSaved: (String value) {
                  this._dati.email = value;
                },
                maxLength: 256,
                decoration: InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail), // We'

            TextFormField(
              onSaved: (String value) {
                this._dati.richiesta = value;
              },
              maxLength: 1000,
              decoration: InputDecoration(
                  labelText: 'Richiesta', prefixIcon: Icon(Icons.edit)),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: validateRichiesta,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _validateInputs,
                    child: Text('Invia', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Colors.redAccent,
                    onPressed: _resetForm,
                    child: Text('reset', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}
