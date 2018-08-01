import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/chi_siamo.dart';
import 'package:innova_service_flutter_project/contatti.dart';
import 'package:innova_service_flutter_project/services_page_view.dart';

import 'home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentTab = 0;

  MyHomePage home;
  MyServicesPageView services;
  ChiSiamo chiSiamo;
  Contatti contatti;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    home = MyHomePage();
    services = MyServicesPageView();
    chiSiamo = ChiSiamo();
    contatti = Contatti();

    pages = [home, services, chiSiamo, contatti];

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
