import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void showHomeModalSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              color: Theme.of(context).primaryColor,
              child: Text(
                "Scegli come contattarci",
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.call,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "chiamaci",
              ),
              subtitle: Text("3391418005",
                  style: TextStyle(color: Color(0xFFCCCCCC))),
              onTap: () {
                contactUs('tel:+393391418005');
              },
            ),
            ListTile(
                leading: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "email",
                ),
                subtitle: Text("info@innovaservice.eu",
                    style: TextStyle(color: Color(0xFFCCCCCC))),
                onTap: () {
                  contactUs('mailto:info@innovaservice.eu');
                }),
            ListTile(
                leading: ImageIcon(
                  AssetImage('asset/images/whatsapp_logo.png'),
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "whatsapp",
                ),
                subtitle: Text("chatta con noi, ricevi una risposta immediata",
                    style: TextStyle(color: Color(0xFFCCCCCC))),
                onTap: () {
                  whatsAppOpen();
                }),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "fai una foto al tuo problema",
              ),
              subtitle: Text(
                  "ti ricontatteremo con la nostra proposta per risolverlo",
                  style: TextStyle(color: Color(0xFFCCCCCC))),
              onTap:() => getImage(context),
            ),
          ],
        );
      });
}

File _image;

Future getImage(BuildContext context) async {
  var image = await ImagePicker.pickImage(source: ImageSource.camera);
  if (image != null) {
    _image = new File(image.path);

    StorageReference storage = FirebaseStorage(
            app: FirebaseApp.instance,
            storageBucket: 'gs://innova-servicve.appspot.com')
        .ref();
    StorageUploadTask uploadImage = storage
        .child('utente')
        .child('${DateTime.now().toUtc().toString()}')
        .putFile(_image);
    await uploadImage.future
        .whenComplete(() => Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("""Grazie per averci inviato la richiesta \nTi ricontatteremo al più presto """),
              duration: Duration(seconds: 4),
            )))
        .catchError((e) => print(e));
  }
}

Future contactUs(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'non è possibile sul tuo dispositivo';
  }
}

void whatsAppOpen() async {
  bool hasWhatsApp = await FlutterLaunch.hasApp(name: "whatsapp");

  if (hasWhatsApp) {
    await FlutterLaunch.launchWathsApp(phone: "+393755070555", message: "");
  } else {
    print("Whatsapp non è installato");
  }
}
