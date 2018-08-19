import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innova_service_flutter_project/main.dart';
import 'package:intl/intl.dart';

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
  Map<String, dynamic> profileData;

  User(this.user);

  /*
*
*   new User instance
*
* */
  static Future<User> instance(FirebaseUser user) async {
    User _currentUser = new User(user);
    _currentUser.email = user.email;
    _currentUser.name = user.displayName;
    _currentUser.uid = user.uid;
    _currentUser.isAnonymous = user.isAnonymous;
    await user.getIdToken().then((token) => _currentUser.idToken = token);
    _currentUser.phoneNumber = user.phoneNumber;
    _currentUser.providerId = user.providerId;
    _currentUser.providerData = user.providerData;
    _currentUser.logged = true;
    //await _currentUser.setProfile();
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

  /*
  *   Logout
  */
  static Future<User> signOut(User _currentUser) async {
    if (_currentUser != null) _currentUser = null;
    return _currentUser;
  }

  /*
  *     add User on Firebase
  */
  void add() async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      Map<String, String> profile = <String, String>{
        'nome ': '${this.name}',
        'email ': '${this.email}',
        'telefono ': '${this.phoneNumber}',
        'uid ': '${this.uid}',
        'n° richieste' : '${richieste}'
      };
      await Firestore.instance
          .document('utenti/${this.name}')
          .setData(profile)
          .whenComplete(() => print('success user added'))
          .catchError((e) => print(e));

      //add session data
      Map<String, String> session = <String, String>{
        'uid ': '${this.uid}',
        'idToken ': '${this.idToken}',
        'data': DateFormat
            .yMd()
            .add_jm()
            .format(DateTime.now())
            .replaceAll('/', '-')
      };
      await Firestore.instance
          .document(
              'utenti/${this.name}/sessioni/${DateFormat.yMd().add_jm().format(DateTime.now()).replaceAll('/', '-')}')
          .setData(session)
          .whenComplete(() => print('success session added'))
          .catchError((e) => print(e));
    });
  }

  /*
  *   get User data
  */

  Future<DocumentSnapshot> get() async {
    DocumentSnapshot userData;
    await Firestore.instance
        .document('utenti/${this.name}')
        .get()
        .then((data) => userData = data)
        .catchError((e) => print(e));
    if (userData.exists) {
      if (userData.data.isNotEmpty) {
        return userData;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  /*
    *   get profile data
    */
  Future<Map<String, dynamic>> getProfileMap() async {
    DocumentSnapshot snapshot = await this.get();
    Map<String, dynamic> profile = snapshot.data;
    return profile;
  }

  /*
    *   filter profile data
    */
  setProfile() async {
    this.profileData = await this.getProfileMap();
    this.profileData.removeWhere((k, v) => k.startsWith('uid'));
    this.profileData.removeWhere((k, v) => v.toString().startsWith('null'));
    print(this.profileData);
  }
}
