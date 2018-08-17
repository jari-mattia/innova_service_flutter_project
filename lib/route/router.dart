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

  MyHomePage home;
  MyServicesPageView services;
  About aboutUs;
  Contacts contacts;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    home = MyHomePage();
    services = MyServicesPageView();
    aboutUs = About();
    contacts = Contacts();
    pages = [home, services, aboutUs, contacts];
    currentPage = home;
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentPage,
        bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).primaryColor,
          currentIndex: currentTab,
          onTap: (int index) {
            setState(() {
              currentTab = index;
              currentPage = pages[index];
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
