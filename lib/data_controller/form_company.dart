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

class FormCompanyState extends State<FormCompany> {
  final _formKey = GlobalKey<FormState>();
  String clientType = 'azienda';
  String date = '';
  String name = '';
  String email = '';
  String pIva = '';
  String request = '';
  String service = '';
  bool _autoValidate = false;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentService;
  bool error;

  List<String> _items = [
    "Pulizie ",
    "Aree Verdi",
    "Impianti",
    "Disinfestazioni",
    "Edilizia"
  ];
  Map<String, dynamic> data = new Map<String, dynamic>();

  DocumentReference document = Firestore.instance.document(
      'utenti/${currentUser.name}/richieste/${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll('/', '-')}');

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems(_items);
    _currentService = null;
    this.error = false;
    super.initState();
  }

  void changedDropDownItem(String selectedCat) {
    print("Selected city $selectedCat, we are going to refresh the UI");
    setState(() {
      _currentService = selectedCat;
      this.service = selectedCat;
    });
  }

  Future<void> _testingEmail(String userId, Map header) async {
    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';

    var from = userId;
    var to = userId;
    var subject =
        'richiesta preventivo da ${googleSignIn.currentUser.displayName}';
    //var message = 'worked!!!';
    var message =
        """${googleSignIn.currentUser.displayName} ti ha inviato una richiesta di preventivo
            \n puoi rispondere all'indirizzo ${userId}
            \n\n questo è il contenuto della richiesta : 
            \n data: ${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll('/', '-')},
            \n cliente : azienda,
            \n nome : ${this.name},
            \n email : ${this.email},
            \n partita iva : ${this.pIva},
            \n servizio : ${this.service},
            \n richiesta : ${this.request}""";
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
      print('error: ' + response.statusCode.toString());

      setState(() {
        this.error = true;
      });
      return;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);

      print('ok: ' + response.statusCode.toString());

      print(data);
      setState(() {
        this.error = false;
      });
    }
  }

  sendMail() async {
    await googleSignIn.currentUser.authHeaders.then((result) async {
      var header = {
        'Authorization': result['Authorization'],
        'X-Goog-AuthUser': result['X-Goog-AuthUser']
      };
      await _testingEmail(googleSignIn.currentUser.email, header);
    });
  }

  Future<void> _pickAndSend() async {
    await sendOnFireStore();
    DocumentSnapshot snapshot = await this.document.get();
    if (snapshot.exists) {
      print('transazione effettuata');

      setState(() {
        this.error = false;
      });
      await sendMail();
    } else {
      print('transazione fallita');

      setState(() {
        this.error = true;
      });
    }
    await _resultMessage(context);
  }

  Future<void> sendOnFireStore() async {
    await document.setData(this.data);
  }

  Future<void> _resultMessage(BuildContext context) async {
    String successMessage = 'Invio Riuscito. Grazie!';
    String errorMessage = 'Ops, Invio Fallito !';

    if (this.error == false) {
      Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 10),
            content: Text(successMessage),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Router())),
            ),
          ));
    } else if (this.error == true) {
      Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 10),
            content: Text(errorMessage),
            action: SnackBarAction(
                label: 'RIPROVA', onPressed: () => _pickAndSend()),
          ));
    } else if (error == null) {
      print('error è null');
    }
  }

  Future<void> onSubmitData(BuildContext context) async {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      setState(() {
        this.date = '${DateFormat
            .yMd()
            .add_jm()
            .format(DateTime.now())
            .replaceAll('/', '-')
            .toString()}';
        this.data = {
          'data': '${this.date}',
          'cliente': '${this.clientType}',
          'nome': '${this.name}',
          'email': '${this.email}',
          'partita iva': '${this.pIva}',
          'servizio': '${this.service}',
          'richiesta': '${this.request}'
        };
      });
      await _pickAndSend().whenComplete(() => _resetForm());
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
        this.error = true;
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
                      setState(() {
                        this.name = value;
                      });
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
                        setState(() {
                          this.pIva = value;
                        });
                      },
                      maxLength: 11,
                      decoration: InputDecoration(
                          labelText: 'Partita Iva', icon: Icon(Icons.payment)),
                      keyboardType: TextInputType.number,
                      validator: validatePIva), // We'l

                  TextFormField(
                      onSaved: (String value) {
                        value = sanitizeTextField(value);
                        setState(() {
                          this.email = value;
                        });
                      },
                      maxLength: 256,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail), // We'

                  TextFormField(
                    onSaved: (String value) {
                      setState(() {
                        this.request = value;
                      });
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
                          onPressed: () async {
                            await onSubmitData(context);
                          },
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
