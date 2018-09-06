import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
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
  // access to the state of Widget
  final _formKey = GlobalKey<FormState>();

  // Client Data to send
  Map<String, dynamic> _clientData = new Map<String, dynamic>();
  String _clientType = 'azienda';
  String _date = '';
  String _name = '';
  String _email = '';
  String _pIva = '';
  String _request = '';
  String _service = '';

  // a controller for the validation of data
  bool _autoValidate = false;

  // a UI component of dropdown
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentService;
  List<String> _items = [
    "Pulizie ",
    "Aree Verdi",
    "Impianti",
    "Disinfestazioni",
    "Edilizia"
  ];

  // a FireStore document reference -- place where stores client data
  DocumentReference _document = Firestore.instance.document(
      'utenti/${currentUser.name}/richieste/${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()).replaceAll('/', '-')}');

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems(_items);
    _currentService = null;
    super.initState();
  }

  //  set a two variable with the choice of Client
  void changedDropDownItem(String selectedCat) {
    print("Selected city $selectedCat, we are going to refresh the UI");
    setState(() {
      _currentService = selectedCat;
      this._service = selectedCat;
    });
  }

  // prepare and send the data to mail
  Future<bool> _testingEmail(String userId, Map header) async {
    bool error;
    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';

    var _from = userId;
    var _to = emailAddress;
    var _subject =
        'richiesta preventivo da ${googleSignIn.currentUser.displayName}';
    //var message = 'worked!!!';
    var _message =
        """<strong> ${googleSignIn.currentUser.displayName} </strong> ti ha inviato una richiesta di preventivo
            <br> puoi rispondere all'indirizzo $userId
            <br> questo è il contenuto della richiesta : 
            <ul>
            <li><strong>data: </strong>${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()).replaceAll('/', '-')}</li>
            <li><strong>cliente : </strong>azienda</li>
            <li><strong>nome : </strong>${this._name}</li>
            <li><strong>email : </strong>${this._email}</li>
            <li><strong>partita iva : </strong>${this._pIva}</li>
            <li><strong>servizio : </strong>${this._service}</li>
            <li><strong>richiesta : </strong>${this._request}</li>
            </ul>""";
    var _content = '''
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: $_to
from: $_from
subject: $_subject

$_message''';

    var _bytes = utf8.encode(_content);
    var _base64 = base64UrlEncode(_bytes);
    var _body = json.encode({'raw': _base64});

    String _url = 'https://www.googleapis.com/gmail/v1/users/' + userId + '/messages/send';

    final http.Response _response = await http.post(_url, headers: header, body: _body);
    if (_response.statusCode != 200) {
      print('error: ' + _response.statusCode.toString());
      error = true;
      setState(() {
      });

    } else {
      final Map<String, dynamic> _data = await json.decode(_response.body);
      error = false;
      print('ok: ' + _response.statusCode.toString());
      print(_data);
      setState(() {
      });
    }
    return error;
  }

  //prepare the header of mail and call _testingEmail()
  Future<bool> sendMail() async {

    Map<String, String> authToken = await googleSignIn.currentUser.authHeaders;
    var header = {
      'Authorization': authToken['Authorization'],
      'X-Goog-AuthUser': authToken['X-Goog-AuthUser']
    };
    bool error = await _testingEmail(googleSignIn.currentUser.email, header);
    return error;
  }

  // store data on FireStore
  Future<Null> sendOnFireStore() async {
    await _document.setData(this._clientData);
  }

  // show a Snackbar() with the result of transaction
  Future<Null> _resultMessage(BuildContext context, bool error) async {
    String successMessage = 'Invio Riuscito. Grazie!';
    String errorMessage = 'Ops, Invio Fallito !';

    if (error == false) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Text(successMessage),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Router())),
        ),
      ));
    } else if (error == true) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Text(errorMessage),
        action: SnackBarAction(
            label: 'RIPROVA', onPressed: () => _pickAndSend()),
      ));
    }
  }

  // call sendOnFireStore and check the result -> then send mail and show result
  Future<Null> _pickAndSend() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('Sto inviando ...'), automaticallyImplyLeading: false),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }));
    await sendOnFireStore();
    DocumentSnapshot snapshot = await this._document.get();
    assert(snapshot.exists);
    bool error = await sendMail();
    Navigator.pop(context);
    await _resultMessage(context, error);
  }

  // reset the State of Widget
  void _resetForm() {
    _formKey.currentState.reset();
    setState(() {
      _autoValidate = false;
      _currentService = null;
    });
  }

  /* check the vaildate of Client data then call _pickAndSend and reset the State of Widget
  *   if data aren't valid sets the autovalidate to true
  * */
  Future<Null> onSubmitData(BuildContext context) async {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      setState(() {
        this._date = '${DateFormat('dd-MM-yyyy HH:mm')
            .format(DateTime.now())
            .replaceAll('/', '-')
            .toString()}';
        this._clientData = {
          'data': '${this._date}',
          'cliente': '${this._clientType}',
          'nome': '${this._name}',
          'email': '${this._email}',
          'partita iva': '${this._pIva}',
          'servizio': '${this._service}',
          'richiesta': '${this._request}'
        };
      });
      await _pickAndSend();
      _resetForm();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
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
                        this._name = value;
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
                          this._pIva = value;
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
                          this._email = value;
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
                        this._request = value;
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
                            var connectivityResult = await (new Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.none) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text('Nessuna Connessione !')));
                            } else  {
                              await onSubmitData(context);
                            }
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
