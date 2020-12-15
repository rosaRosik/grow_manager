import 'package:flutter/material.dart';
import 'package:growapp/Statistic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'SwitchWidget.dart';

final String url = 'http://192.168.1.27/api';

Future<Statistic> fetchStatistics() async {
  final response = await http.get(url + '/statistic');
  if (response.statusCode == 200) {
    return Statistic.fromJson(jsonDecode(response.body));
  } else {
    var statistics = new Statistic();
    statistics.temperature = 0;
    statistics.environmentMoisture = 0;
    statistics.soilMoisture = 0;
    return statistics;
  }
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
  Future<Statistic> futureStatistics;

  @override
  void initState() {
    super.initState();
    futureStatistics = fetchStatistics();
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      setState(() {
        futureStatistics = fetchStatistics();
      });
    });
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
        body: FutureBuilder<Statistic>(
            future: futureStatistics,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var statistic = snapshot.data;
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Image(image: AssetImage('graphics/temp.png'), height: 50, width: 50),
                          basicText(" TEMPERATURA: "),
                          basicContainer(statistic.temperature.toString() + "°C"),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10, height: 75),
//                          Image(image: AssetImage('graphics/humidity.png'), height: 30, width: 30),
                          basicText(" WILGOTNOŚĆ :"),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 25, height: 0,),
                          Image(image: AssetImage('graphics/air.png'), height: 50, width: 50),
                          basicText("  powietrza: "),
                          basicContainerLowPadding(statistic.environmentMoisture.toString() + "%"),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 25, height: 0,),
                          Image(image: AssetImage('graphics/soil.png'), height: 50, width: 50),
                          basicText(" gleby: "),
                          basicContainerLowPadding(statistic.soilMoisture.toString() + "%"),
                        ],
                      ),
                      SizedBox(height: 30),
                      SwitchWidget()
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
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