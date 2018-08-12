import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';



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

/*  VALIDATOR */

String sanitizeTextField(String value) {
  if (value.isNotEmpty) value = value.trim().toLowerCase();
  return value;
}

String sanitizeFiscalCode(String value) {
  if (value.isNotEmpty) value = value.trim().toUpperCase();
  return value;
}

String sanitizePIva(String value) {
  if (value.isNotEmpty) value = value.trim();
  return value;
}


String validateFirstName(String value) {
  if (value.length < 3)
    return 'il nome deve contenere almeno 3 caratteri';
  else
    return null;
}

String validateLastName(String value) {
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

String validatePassword(String value) {
  Pattern pattern =
      r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,20}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'inserisci una password valida';
  else
    return null;
}

String validateFiscalCode(String value) {
  Pattern pattern =
      r'^[a-zA-Z]{6}[0-9]{2}[a-zA-Z][0-9]{2}[a-zA-Z][0-9]{3}[a-zA-Z]$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'inserisci un Codice Fiscale valido';
  else
    return null;
}

String validatePIva(String value) {
  Pattern pattern = r'^[0-9]{11}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'inserisci una partita iva valida';
  else
    return null;
}

String validateRequest(String value) {
  if (value.isEmpty)
    return 'inserisci la richiesta ';
  else
    return null;
}



/*  UI ELEMENTS */

//A DYNAMIC DROPDOWN LIST FOR DROPDOWN MENU ITEM
List<DropdownMenuItem<String>> getDropDownMenuItems(List<String> _items) {
  List<DropdownMenuItem<String>> itemsList = new List();

  for (String _item in _items) {
    itemsList.add(
        new DropdownMenuItem(value: _item, child: new Text(_item)));
  }
  return itemsList;
}