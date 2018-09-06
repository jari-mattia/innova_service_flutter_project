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

  // a controller for the state of transaction
  bool _error;

  // access to the state of Widget
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // a List of upload
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  // the Uri where stored the image
  Uri _uploadedImageUri;


  @override
  initState() {
    this._error = false;
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
  Future<StorageReference> sendImageOnStorage() async {
    StorageReference ref;
    StorageReference storage = FirebaseStorage(
            app: widget.app,
            storageBucket: 'gs://innova-servicve.appspot.com')
        .ref();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }));
    try {
       ref = storage
          .child('${currentUser.name} - ${currentUser.email}')
          .child(
              '${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll('/', '-')}');

      final StorageUploadTask uploadTask = ref.putFile(_image);
       setState(() {
         _tasks.add(uploadTask);
       });


    } catch (e) {
      print('eccezione sollevata da cloud_storage : ' + e);
      setState(() {
        this._error = true;
      });
    } finally {
      Navigator.pop(context);
    }
    return ref;
  }

  Future<String> _downloadFile(StorageReference ref) async {
    try {
      String url = await ref.getDownloadURL();
      print(url);
      return url;
    } catch (e) {
      print('Eccezione in url : '+e);
    }
  }
  // prepare and send the data to mail
  Future<bool> _testingEmail(String userId, Map header, String uri) async {
    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';
    bool error;
    var from = userId;
    var to = emailAddress;
    var subject =
        'richiesta preventivo da ${googleSignIn.currentUser.displayName}';
    //var message = 'worked!!!';
    var message =
    '''${googleSignIn.currentUser.displayName} 
        ti ha inviato una richiesta di preventivo tramite un immagine
        puoi rispndere all'indirizzo $userId''';

    var content = '''
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: $to
from: $from
subject: $subject
$message''';

    var bytes = utf8.encode(content);
    var base64 = base64Encode(bytes);
    var body = json.encode({'raw': base64});

    String url = 'https://www.googleapis.com/gmail/v1/users/' +
        userId +
        '/messages/send';

    final http.Response response =
        await http.post(url, headers: header, body: body);
    if (response.statusCode != 200 ) {
      setState(() {
        print('error: ' + response.statusCode.toString());
        error = true;
      });
    }
    else {
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
  Future<bool> _sendMail(String uri) async {
    await googleSignIn.currentUser.authHeaders.then((result) {
      var header = {
        'Authorization': result['Authorization'],
        'X-Goog-AuthUser': result['X-Goog-AuthUser']
      };
      _testingEmail(googleSignIn.currentUser.email, header, uri);
    });
  }

  // show a Snackbar() with the result of transaction
  void _resultMessage(bool error)  {
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
  Future<Null> _pickAndSend() async {
    await picker();
    StorageReference ref = await sendImageOnStorage();
    String uri = await _downloadFile(ref);
    bool error = await _sendMail(uri);
    _resultMessage(error);

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
