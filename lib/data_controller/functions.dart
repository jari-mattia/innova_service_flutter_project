import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_launch/flutter_launch.dart';

// launches an url
Future contactUs(url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("applicazione non trovata su questo dispositivo")));
  }
}

// launches WhatsApp
void whatsAppOpen(BuildContext context) async {
  if (await canLaunch("whatsapp://send?phone=+393755070555")) {
    await launch("whatsapp://send?phone=+393755070555");
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Whatsapp non è installato")));
  }

}

void whatsAppOpenIos(BuildContext context) async {
  bool whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");

  if (whatsapp) {
    await FlutterLaunch.launchWathsApp(phone: "+393755070555" , message: "");
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Whatsapp non è installato")));
  }
}

/*  VALIDATOR */

// trim the field and convert in lower case
String sanitizeTextField(String value) {
  if (value.isNotEmpty) value = value.trim().toLowerCase();
  return value;
}

// trim the field and convert in Upper Case
String sanitizeFiscalCode(String value) {
  if (value.isNotEmpty) value = value.trim().toUpperCase();
  return value;
}

// trim the field
String sanitizePIva(String value) {
  if (value.isNotEmpty) value = value.trim();
  return value;
}

// field must have 3 char at least
String validateFirstName(String value) {
  if (value.length < 3)
    return 'il nome deve contenere almeno 3 caratteri';
  else
    return null;
}

// field must have 3 char at least
String validateLastName(String value) {
  if (value.length < 3)
    return 'il cognome deve contenere almeno 3 caratteri';
  else
    return null;
}

// check for a valid email address through Reg Ex
String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'inserisci un email valida';
  else
    return null;
}

// validate a password -- this method is never used after the introduction of Google  Sign in
/*
String validatePassword(String value) {
  Pattern pattern =
      r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,20}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'inserisci una password valida';
  else
    return null;
}
*/

// validates a Fiscal Code through a Reg Ex
String validateFiscalCode(String value) {
  Pattern pattern =
      r'^[a-zA-Z]{6}[0-9]{2}[a-zA-Z][0-9]{2}[a-zA-Z][0-9]{3}[a-zA-Z]$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'inserisci un Codice Fiscale valido';
  else
    return null;
}

// validates a Fiscal Code through a Reg Ex
String validatePIva(String value) {
  Pattern pattern = r'^[0-9]{11}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'inserisci una partita iva valida';
  else
    return null;
}

// request cannot be empty
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