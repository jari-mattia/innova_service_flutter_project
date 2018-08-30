import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:innova_service_flutter_project/route/router.dart';
import 'package:intl/intl.dart';

class SendImage extends StatefulWidget {
  @override
  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  File image;
  bool send;
  bool error;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Uri _uploadedImageUri;

  @override
  initState() {
    this.error = false;
    super.initState();
  }

  picker() async {
    print('Picker is called');
    double height = 1000.0;
    double width = 1000.0;
    File img = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: height, maxWidth: width);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Future<UploadTaskSnapshot> sendImageOnStorage() async {
    UploadTaskSnapshot uploadImage;
    StorageReference storage = FirebaseStorage(
            app: FirebaseApp.instance,
            storageBucket: 'gs://innova-servicve.appspot.com')
        .ref();
    uploadImage = await storage
        .child('${currentUser.name} - ${currentUser.email}')
        .child('${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll(
        '/', '-')}')
        .putFile(image)
        .future;

    return uploadImage;
  }

  checkUri() async {
    Uri _uri;
    await sendImageOnStorage().then((uri) => _uri = uri.downloadUrl);
    if (_uri == null) throw Exception;
    setState(() {
      this.error = true;
    });
  }

  Future<void> testingEmail(String userId, Map header, Uri uri) async {
    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';

    var from = userId;
    var to = userId;
    var subject =
        'richiesta preventivo da ${googleSignIn.currentUser.displayName}';
    //var message = 'worked!!!';
    var message =
        "${googleSignIn.currentUser.displayName} ti ha inviato una richiesta di preventivo tramite un immagine\n\n  ${uri.toString()}\n\n puoi rispndere all'indirizzo ${userId}";
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
    if (response.statusCode != 200 || uri == null) {
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

  Future<void> sendMail(Uri uri) async {
    await googleSignIn.currentUser.authHeaders.then((result) {
      var header = {
        'Authorization': result['Authorization'],
        'X-Goog-AuthUser': result['X-Goog-AuthUser']
      };
      testingEmail(googleSignIn.currentUser.email, header, uri);
    });
  }

  Future<void> _resultMessage() async {
    String successMessage =
        'Grazie per averci inviato la richiesta \nTi ricontatteremo al più presto';
    String errorMessage =
        'Non è stato possibile inviare la richiesta. \nVerifichi di essere connesso alla rete';

    if (this.error == false) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Text(successMessage),
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Navigator.popAndPushNamed(context, '/home');
            }),
      ));
    } else if (this.error == true) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Text(errorMessage),
        action:
            SnackBarAction(label: 'RIPROVA', onPressed: () => _pickAndSend()),
      ));
    } else if (error == null) {
      print('error è null');
    }
  }

  Future<void> _pickAndSend() async {
    await picker();
    try {
      await sendImageOnStorage()
              .then((snapshot) => _uploadedImageUri = snapshot.downloadUrl);
    } catch (e) {
      print('transazione fallita');
    }
    if (_uploadedImageUri != null) {
      print('transazione effettuata');

      setState(() {
        this.error = false;
      });
      await sendMail(_uploadedImageUri);
    } else {
      print('transazione fallita');

      setState(() {
        this.error = true;
      });
    }
    await _resultMessage();
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
          title: new Text('Inviaci una Foto'),
        ),
        body: new Container(
          child: new Center(
            child: image == null
                ? new Text('nessuna foto da mostrare ')
                : new Image.file(image),
          ),
        ),
        floatingActionButton: Builder(
            builder: (context) => new FloatingActionButton(
                  onPressed: () {
                    _pickAndSend();
                  },
                  child: new Icon(Icons.camera_alt),
                )),
      ),
    );
  }
}
