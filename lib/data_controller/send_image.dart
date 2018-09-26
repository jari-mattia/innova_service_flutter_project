import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:intl/intl.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';

class NoImage extends StatefulWidget {
  @override
  _NoImageState createState() => _NoImageState();
}

class _NoImageState extends State<NoImage> {
  // an image picked from picker()
  File _image;

  // access to the state of Widget
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // get an image from camera
  Future picker() async {
    double height = 1000.0;
    double width = 1000.0;
    var img = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: height, maxWidth: width);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ImageScreen(_image)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text('Inviaci una Foto'),
      ),
      body: new Container(
        child: new Center(
            child: new Text('nessuna foto da mostrare ')
                ),
      ),
      floatingActionButton: Builder(
          builder: (context) => new FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  await picker();
                },
                child: new Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              )),
    );
  }
}

class ImageScreen extends StatefulWidget {
  final File _image;

  ImageScreen(this._image);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  // the position on the storage
  final StorageReference storage = FirebaseStorage(
          app: FirebaseApp.instance,
          storageBucket: 'gs://innova-servicve.appspot.com')
      .ref()
      .child('${currentUser.name} - ${currentUser.email}')
      .child(
          '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()).replaceAll('/', '-')}');

  // access to the state of Widget
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _request = '';
  bool _autoValidate = false;
  bool _enabled = true;

  Future<UploadTaskSnapshot> storeImage() async {
    UploadTaskSnapshot uploadImage =
        await storage.putFile(widget._image).future;
    return uploadImage;
  }

  // prepare and send the data to mail
  Future<bool> _testingEmail(String userId, Map header, Uri uri) async {
    bool error;
    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';
    var from = userId;
    var to = emailAddress;
    var subject =
        'richiesta preventivo da ${googleSignIn.currentUser.displayName}';
    //var message = 'worked!!!';
    var message = '''
    ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()).replaceAll('/', '-')}<hr>
    <strong>${googleSignIn.currentUser.displayName}</strong><br>
    ti ha inviato una richiesta di preventivo tramite un immagine <br>
    <a href="${uri.toString()}"> <strong> clicca qui </strong></a> <br>
    il cliente chiede : ${this._request} <br>
    puoi rispondere all'indirizzo $userId
    ''';

    var content = '''
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: $to
from: $from
subject: $subject

 $message''';

    var bytes = utf8.encode(content);
    var base64 = base64UrlEncode(bytes);
    var body = json.encode({'raw': base64});

    String url = 'https://www.googleapis.com/gmail/v1/users/' +
        userId +
        '/messages/send';

    final http.Response response =
        await http.post(url, headers: header, body: body);
    if (response.statusCode != 200) {
      error = true;
      setState(() {
        print('error: ' + response.statusCode.toString());
      });
    } else {
      final Map<String, dynamic> data = await json.decode(response.body);
      error = false;
      print(data);
      setState(() {
        print('ok: ' + response.statusCode.toString());
      });
    }
    return error;
  }

  //prepare the header of mail and call _testingEmail()
  Future<bool> _sendMail(Uri uri) async {
    Map<String, String> authToken = await googleSignIn.currentUser.authHeaders;
    var header = {
      'Authorization': authToken['Authorization'],
      'X-Goog-AuthUser': authToken['X-Goog-AuthUser']
    };
    bool error =
        await _testingEmail(googleSignIn.currentUser.email, header, uri);
    return error;
  }

  // call picker -> then sendImageOnStorage() and check the Uri result -> then send mail and show result
  Future<Null> _pickAndSend() async {
    if (widget._image != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text('Sto inviando ...'),
              automaticallyImplyLeading: false),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }));
      //StorageReference ref = await sendImageOnStorage();
      UploadTaskSnapshot snapshot = await storeImage();
      Uri uri = snapshot.downloadUrl;
      assert(uri != null);
      bool error = await _sendMail(uri);
      assert(error != null);
      Navigator.pop(context);
      setState(() => _enabled = false);
      await _resultMessage(error);
    } else
      Navigator.popAndPushNamed(context, '/noImage');
  }

  // show a Snackbar() with the result of transaction
  Future<Null> _resultMessage(bool error) async {
    String successMessage =
        'Grazie per averci inviato la richiesta \nTi ricontatteremo al più presto';
    String errorMessage =
        'Non è stato possibile inviare la richiesta. \nVerifichi di essere connesso alla rete';

    if (error == false) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(successMessage),
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Navigator.pop(context);
            }),
      ));
    } else if (error == true) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Text(errorMessage),
        action:
            SnackBarAction(label: 'RIPROVA', onPressed: () => _pickAndSend()),
      ));
    }
  }

  Future<Null> onSubmit() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 4),
          content: Text('Nessuna Connessione !')));
    } else {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        _formKey.currentState.save();
        setState(() {});
        await _pickAndSend();
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget._image != null) {
      return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.popAndPushNamed(context, '/noImage')),
            automaticallyImplyLeading: true,
            title: new Text('Inviaci una Foto'),
          ),
          body: new Stack(children: <Widget>[
            new Container(
              child: Center(
                child: new Image.file(widget._image, fit: BoxFit.cover,),
              ),
            ),
            new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 90.0),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.elliptical(40.0, 40.0)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0)]),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: TextFormField(
                          enabled: _enabled,
                          onSaved: (String value) {
                            this._request = value;
                          },
                          maxLength: 1000,
                          decoration: InputDecoration(
                              labelText: 'Inserisci Richiesta',
                              icon: Icon(Icons.edit),
                              filled: true,
                              fillColor: Colors.white,
                              ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          validator: validateRequest,
                        ),
                      )),
                ])
          ]),
          floatingActionButton: Builder(
              builder: (context) =>
              new FloatingActionButton(
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
                onPressed: () async {
                  await onSubmit();
                },
                child: new Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ))
      );
    }else{
      return NoImage();
    }
  }
}
