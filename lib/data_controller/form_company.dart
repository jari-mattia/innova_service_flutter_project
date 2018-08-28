import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:innova_service_flutter_project/route/router.dart';
import 'package:intl/intl.dart';

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
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  _CompanyData _data = new _CompanyData();
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCat;
  bool error;

  List<String> _items = [
    "Pulizie ",
    "Aree Verdi",
    "Impianti",
    "Disinfestazioni",
    "Edilizia"
  ];

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems(_items);
    _currentCat = null;
    error = false;
    super.initState();
  }

  void changedDropDownItem(String selectedCat) {
    print("Selected city $selectedCat, we are going to refresh the UI");
    setState(() {
      _currentCat = selectedCat;
      _data.service = selectedCat;
    });
  }

  Future<Null> testingEmail(String userId, Map header) async {
    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';

    var from = userId;
    var to = userId;
    var subject =
        'richiesta preventivo da ${googleSignIn.currentUser.displayName}';
    //var message = 'worked!!!';
    var message =
        "${googleSignIn.currentUser.displayName} ti ha inviato una richiesta di preventivo" +
            " \n puoi rispondere all'indirizzo ${userId}" +
            " \n\n questo è il contenuto della richiesta : " +
            " \n data: ${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll('/', '-')}," +
            " \n cliente : azienda," +
            " \n nome : ${_data.nome}," +
            " \n email : ${_data.email}," +
            " \n partita iva : ${_data.pIva}," +
            " \n servizio : ${_data.service}," +
            " \n richiesta : ${_data.request}";
    var content = '''
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: ${to}
from: ${from}
subject: ${subject}

${message}''';

    var bytes = utf8.encode(content);
    var base64 = base64Encode(bytes);
    var body = json.encode({'raw': base64});

    String url = 'https://www.googleapis.com/gmail/v1/users/' +
        userId +
        '/messages/send';

    final http.Response response =
        await http.post(url, headers: header, body: body);
    if (response.statusCode != 200) {
      setState(() {
        print('error: ' + response.statusCode.toString());
        this.error = true;
      });
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      print('ok: ' + response.statusCode.toString());
      this.error = false;
      print(data);
    });
  }

  sendMail() async {
    await googleSignIn.currentUser.authHeaders.then((result) {
      var header = {
        'Authorization': result['Authorization'],
        'X-Goog-AuthUser': result['X-Goog-AuthUser']
      };
      testingEmail(googleSignIn.currentUser.email, header);
    });
  }

  void _resultMessage(BuildContext context) {
    String successMessage =
        'Grazie per averci inviato la richiesta \nTi ricontatteremo al più presto';
    String errorMessage =
        'Non è stato possibile inviare la richiesta. \nVerifichi di essere connesso alla rete';

    if (this.error == false) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(successMessage), duration: Duration(seconds: 4)));
    } else if (this.error == true) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage), duration: Duration(seconds: 4)));
    } else if (error == null) {
      print('error è null');
    }
  }

  void onSubmitData() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();

      Firestore.instance
          .runTransaction((Transaction transaction) async {
            DocumentReference document = Firestore.instance.document(
                'utenti/${currentUser.name}/richieste/${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll('/', '-')}');
            await document.setData(<String, String>{
              'data':
                  '${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll('/', '-')}',
              'cliente': 'azienda',
              'nome': _data.nome,
              'email': _data.email,
              'partita iva': _data.pIva,
              'servizio': _data.service,
              'richiesta': _data.request
            });
          })
          .whenComplete(() => sendMail())
          .whenComplete(() => _resultMessage(context))
          .whenComplete(_resetForm)
          .whenComplete(() => setState(() => ++requests))
          .whenComplete(() => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Router())))
          .catchError((e) => print(e));
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState.reset();
    setState(() {
      _autoValidate = false;
      _currentCat = null;
    });
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
                      value = sanitizeTextField(value);
                      this._data.nome = value;
                    },
                    onFieldSubmitted: validateFirstName,
                    maxLength: 24,
                    decoration: InputDecoration(
                        labelText: 'Nome', icon: Icon(Icons.group)),
                    validator: validateFirstName,
                  ), // We'll build this out in the next steps!

                  TextFormField(
                      onSaved: (String value) {
                        value = sanitizePIva(value);
                        this._data.pIva = value;
                      },
                      maxLength: 11,
                      decoration: InputDecoration(
                          labelText: 'Partita Iva', icon: Icon(Icons.payment)),
                      keyboardType: TextInputType.number,
                      validator: validatePIva), // We'l

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
