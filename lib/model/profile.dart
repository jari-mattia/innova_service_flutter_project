import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/main.dart';

class ProfileList extends StatelessWidget {
  final Map<String, dynamic> _values = currentUser.profileData;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      shrinkWrap: true,
        itemCount: _values.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
            new ListTile(
              leading: new Text(
                _values.keys.elementAt(index),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              title: new Text(_values.values.elementAt(index)),
            ),
              Divider(),
          ]);
        });
  }
}
