import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:innova_service_flutter_project/model/profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          new ListTile(
              leading: new GoogleUserCircleAvatar(
                identity: googleCurrentUser,
              )),
          ProfileList()
        ],
      ),
    );
  }
}
