import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

//  To use Gallery or File Manager to pick Image
//  Comment Line No. 19 and uncomment Line number 20
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

  Future<UploadTaskSnapshot> sendImage() async {
    StorageReference storage = FirebaseStorage(
            app: FirebaseApp.instance,
            storageBucket: 'gs://innova-servicve.appspot.com')
        .ref();
    StorageUploadTask uploadImage = storage
        .child('${currentUser.name} - ${currentUser.email}')
        .child('${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll(
        '/', '-')}')
        .putFile(image);
    return await uploadImage.future;
  }

  pickAndSend() async {
    await picker();
    sendImage()
        .then((value) => value.downloadUrl)
        .then((uri) => sendMail(uri))
        .whenComplete(() => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Router())));
  }

sendMail(Uri uri) async {
  await googleSignIn.currentUser.authHeaders.then((result) {
    var header = {'Authorization': result['Authorization'], 'X-Goog-AuthUser': result['X-Goog-AuthUser']};
    testingEmail(googleSignIn.currentUser.email, header, uri);
  });
      }

  Future<Null> testingEmail(String userId, Map header, Uri uri) async {

    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';

    var from = userId;
    var to = userId;
    var subject = 'richiesta preventivo da ${googleSignIn.currentUser.displayName}';
    //var message = 'worked!!!';
    var message = "${googleSignIn.currentUser.displayName} ti ha inviato una richiesta di preventivo tramite un immagine\n\n  ${uri.toString()}\n\n puoi rispndere all'indirizzo ${userId}";
    var content = '''
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: ${to}
from: ${from}
subject: ${subject}

${message}''';

    var bytes = utf8.encode(content);
    var base64 = base64Encode(bytes);
    var body = json.encode({'raw': base64});

    String url = 'https://www.googleapis.com/gmail/v1/users/' + userId + '/messages/send';

    final http.Response response = await http.post(
        url,
        headers: header,
        body: body
    );
    if (response.statusCode != 200) {
      setState(() {
        print('error: ' + response.statusCode.toString());
      });
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              """Non è stato possibile inviare la richiesta. \nVerifichi di essere connesso alla rete """),
          duration: Duration(seconds: 4)));
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    print('ok: ' + response.statusCode.toString());
    print(data);
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
        """Grazie per averci inviato la richiesta \nTi ricontatteremo al più presto """),
    duration: Duration(seconds: 4)));
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
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
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            pickAndSend();
          },
          child: new Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}
