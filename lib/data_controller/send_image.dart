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
import 'package:innova_service_flutter_project/route/router.dart';
import 'package:intl/intl.dart';

class SendImage extends StatefulWidget {
  SendImage({this.app});
  final FirebaseApp app;
  @override
  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  // an image picked from picker()
  File _image;

  // access to the state of Widget
  final _scaffoldKey = GlobalKey<ScaffoldState>();

 bool _error;

  @override
  initState() {
    _error = false;
    super.initState();
  }

  // get an image from camera
  picker() async {
    print('Picker is called');
    double height = 1000.0;
    double width = 1000.0;
    File img = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: height, maxWidth: width);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _image = img;
      setState(() {});
    }
  }

  // store the image on Cloud Storage and generate an Uri
  Future<UploadTaskSnapshot> sendImage() async {
    StorageUploadTask uploadImage;
    StorageReference storage = FirebaseStorage(
            app: FirebaseApp.instance,
            storageBucket: 'gs://innova-servicve.appspot.com')
        .ref();

    /*Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }));*/

    try {
      uploadImage = storage
              .child('${currentUser.name} - ${currentUser.email}')
              .child(
                  '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()).replaceAll('/', '-')}')
              .putFile(_image);
    } catch (e) {
      print(e);
    } //finally {Navigator.pop(context);}

    return await uploadImage.future;
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
    puoi rispondere all'indirizzo $userId
    ''';

    var content = '''
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: ${to}
from: ${from}
subject: ${subject}

 ${message}''';

    var bytes = utf8.encode(content);
    var base64 = base64UrlEncode(bytes);
    var body = json.encode({'raw': base64});

    String url = 'https://www.googleapis.com/gmail/v1/users/' +
        userId +
        '/messages/send';

    final http.Response response =
        await http.post(url, headers: header, body: body);
    if (response.statusCode != 200) {
      setState(() {
        print('error: ' + response.statusCode.toString());
        error = true;
      });
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        print('ok: ' + response.statusCode.toString());
        error = false;
        print(data);
      });
    }
    return error;
  }

  //prepare the header of mail and call _testingEmail()
  Future<bool> _sendMail(Uri uri) async {
    await googleSignIn.currentUser.authHeaders.then((result) {
      var header = {
        'Authorization': result['Authorization'],
        'X-Goog-AuthUser': result['X-Goog-AuthUser']
      };
      _testingEmail(googleSignIn.currentUser.email, header, uri);
    });
  }

  // show a Snackbar() with the result of transaction
  Future<Null> _resultMessage(bool error) async {
    String successMessage =
        'Grazie per averci inviato la richiesta \nTi ricontatteremo al più presto';
    String errorMessage =
        'Non è stato possibile inviare la richiesta. \nVerifichi di essere connesso alla rete';

    if (error == false) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
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

  // call picker -> then sendImageOnStorage() and check the Uri result -> then send mail and show result
  Future<void> _pickAndSend() async {
    await picker();
    //StorageReference ref = await sendImageOnStorage();
    UploadTaskSnapshot snapshot = await sendImage();
    Uri uri = snapshot.downloadUrl;
    bool error = await _sendMail(uri);
    setState(() {
      this._error = error;
    });
    await _resultMessage(error);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Router()
      }, //HandleCurrentScreen()
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
          automaticallyImplyLeading: true,
          title: new Text('Inviaci una Foto'),
        ),
        body: new Container(
          child: new Center(
            child: _image == null
                ? new Text('nessuna foto da mostrare ')
                : new Image.file(_image),
          ),
        ),
        floatingActionButton: Builder(
            builder: (context) => new FloatingActionButton(
                  onPressed: () async {
                    var connectivityResult =
                        await (new Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text('Nessuna Connessione !')));
                    } else {
                      _pickAndSend();

                    }
                  },
                  child: new Icon(Icons.camera_alt),
                )),
      ),
    );
  }
}
