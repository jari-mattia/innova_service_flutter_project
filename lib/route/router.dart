import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/route/about.dart';
import 'package:innova_service_flutter_project/route/contacts.dart';
import 'package:innova_service_flutter_project/route/home_page.dart';
import 'package:innova_service_flutter_project/route/services_page_view.dart';

class Router extends StatefulWidget {
  @override
  _RouterState createState() => new _RouterState();
}

class _RouterState extends State<Router> {
  int currentTab = 0;

  MyHomePage _home;
  MyServicesPageView _services;
  About _aboutUs;
  Contacts _contacts;
  List<Widget> _pages;
  Widget _currentPage;

  @override
  void initState() {
    _home = MyHomePage();
    _services = MyServicesPageView();
    _aboutUs = About();
    _contacts = Contacts();
    _pages = [_home, _services, _aboutUs, _contacts];
    _currentPage = _home;
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentPage,
        bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).primaryColor,
          currentIndex: currentTab,
          onTap: (int index) {
            setState(() {
              currentTab = index;
              _currentPage = _pages[index];
            });
          },
type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,color: Colors.white,), title: Text('Home'),backgroundColor: Colors.black54),
            BottomNavigationBarItem(
                icon: Icon(Icons.build, color :Colors.white), title: Text('Servizi'),backgroundColor: Colors.black54),
            BottomNavigationBarItem(
                icon: Icon(Icons.group,color: Colors.white), title: Text('Chi Siamo'),backgroundColor: Colors.black54),
            BottomNavigationBarItem(
                icon: Icon(Icons.email, color :  Colors.white), title: Text('Contatti'),backgroundColor: Colors.black54),
          ],
        ),
      );
  }
}
