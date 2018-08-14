import 'package:flutter/material.dart';

import 'package:innova_service_flutter_project/route/about.dart';
import 'package:innova_service_flutter_project/route/contacts.dart';
import 'package:innova_service_flutter_project/route/home_page.dart';
import 'package:innova_service_flutter_project/route/services_page_view.dart';

void main() => runApp(new Router());

class Router extends StatefulWidget {
  @override
  _RouterState createState() => new _RouterState();
}

class _RouterState extends State<Router> {
  int currentTab = 0;

  MyHomePage home;
  MyServicesPageView services;
  ChiSiamo aboutUs;
  Contacts contacts;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    home = MyHomePage();
    services = MyServicesPageView();
    aboutUs = ChiSiamo();
    contacts = Contacts();
    pages = [home, services, aboutUs, contacts];
    currentPage = home;
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Innova Service',
      theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: Colors.blue,
          accentColor: Colors.cyan),
      home: Scaffold(

        body: currentPage,
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.black54,
          currentIndex: currentTab,
          onTap: (int index) {
            setState(() {
              currentTab = index;
              currentPage = pages[index];
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.build), title: Text('Servizi')),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), title: Text('Chi Siamo')),
            BottomNavigationBarItem(
                icon: Icon(Icons.email), title: Text('Contatti')),
          ],
        ),
      ),
    );
  }
}
