import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final FirebaseUser user;
  String email;
  String name;
  String uid;
  bool isAnonymous;
  String idToken;
  String phoneNumber;
  String providerId;
  List<UserInfo> providerData;
  bool logged;

  User(this.user);

  static Future<User> instance(FirebaseUser user) async {
    User _currentUser = new User(user);
    _currentUser.email = user.email;
    _currentUser.name = user.displayName;
    _currentUser.uid = user.uid;
    _currentUser.isAnonymous = user.isAnonymous;
    user.getIdToken().then((token) => _currentUser.idToken = token);
    _currentUser.phoneNumber = user.phoneNumber;
    _currentUser.providerId = user.providerId;
    _currentUser.providerData = user.providerData;
    _currentUser.logged = true;
    assert(_currentUser != null);
    assert(_currentUser.email != null);
    assert(_currentUser.uid != null);
    assert(!_currentUser.isAnonymous);
    //assert(_currentUser.idToken != null);
    assert(_currentUser.providerData != null);
    assert(_currentUser.providerId != null);
    assert(_currentUser.logged != null);
    return _currentUser;
  }

  static Future<User> signOut(User _currentUser) async {
    if (_currentUser != null) _currentUser = null;
    return _currentUser;
  }

  void add() {
    Map<String, String> profile = <String, String>{
      'nome ': '${this.name}',
      'email ': '${this.email}',
      'telefono ': '${this.phoneNumber}',
      'uid ': '${this.uid}',
    };
    Firestore.instance
        .document('utenti/${this.name}')
        .setData(profile)
        .whenComplete(() => print('success added'))
        .catchError((e) => print(e));

    Map<String, String> session = <String, String>{
      'uid ': '${this.uid}',
      'idToken ': '${this.idToken}',
      'data' : '${DateTime.now().toUtc().toString()}'
    };
    Firestore.instance
        .document('utenti/${this.name}/sessioni/${DateTime.now().toUtc().toString()}')
        .setData(session)
        .whenComplete(() => print('success added'))
        .catchError((e) => print(e));
  }
}
