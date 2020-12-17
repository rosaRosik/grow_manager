import 'package:flutter/material.dart';
import 'package:growapp/Statistic.dart';
import 'package:growapp/statisticPage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'deviationState.dart';


final String url = 'http://192.168.1.27/api';

void savePushToken(String token) async {
  final response = await http.post(url + '/pushToken/' + token);
  print(response);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _GrowAppState createState() => _GrowAppState();
}

class _GrowAppState extends State<MyApp> {

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: new Icon(Icons.eco_outlined),
        label: 'Statystki',
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.announcement_outlined),
        label: 'Historia',
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: [
        StatisticPage(),
        DeviationPage(),
      ],
    );
  }

  @override
  void initState() {
    _register();
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }
  
  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<Statistic> futureStatistics;

  _register() {
    _firebaseMessaging.getToken().then((token) => savePushToken(token));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grow Monitor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Grow Monitor'),
        ),
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
      ),
    );
  }
}

Text basicText(String text) {
  return Text(text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.grey[200],
          fontSize: 22,
          fontWeight: FontWeight.w500,
          fontFamily: 'Open Sans',
          fontStyle: FontStyle.italic));
}

Text basicLowerText(String text) {
  return Text(text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.grey[200],
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Open Sans',
          fontStyle: FontStyle.italic));
}

Container basicContainer(String text) {
  return Container(
    margin: const EdgeInsets.all(15.0),
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      border: Border.all(width: 3.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    child: basicText(text),
  );
}

Container basicContainerLowPadding(String text) {
  return Container(
    margin: const EdgeInsets.all(3.0),
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      border: Border.all(width: 3.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    child: basicText(text),
  );
}
