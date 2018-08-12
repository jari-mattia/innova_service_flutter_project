import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class User {

  final FirebaseUser user;
  String email;
  String name;
  String uid;
  bool isAnonymous;
  Future<String> idToken;
  String phoneNumber;
  String providerId;
  List<UserInfo> providerData;
  bool logged;

  User(this.user);

   static instance(FirebaseUser user) {
   User _currentUser = new User(user);
   _currentUser.email = user.email;
   _currentUser.name = user.displayName;
   _currentUser.uid = user.uid;
   _currentUser.isAnonymous = user.isAnonymous;
   _currentUser.idToken = user.getIdToken();
   _currentUser.phoneNumber = user.phoneNumber;
   _currentUser.providerId = user.providerId;
   _currentUser.providerData = user.providerData;
   _currentUser.logged = false;
    return _currentUser;
  }
}

