import 'package:flutter/material.dart';
import 'package:growapp/Statistic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'SwitchWidget.dart';

final String url = 'http:///api';

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
        appBar: AppBar(
          title: Text('Grow Monitor'),
        ),
        body: FutureBuilder<Statistic> (
        future: futureStatistics,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var statistic = snapshot.data;
                return Center(
                  child: Column(
                    children: [
                      Text("Temperatura: " +
                      statistic.temperature.toString() +
                      "\nWilgotność powietrza: " +
                      statistic.environmentMoisture.toString() +
                      "\nWilgotność gleby: " +
                      statistic.soilMoisture.toString()),

                      SwitchWidget()
                    ],
                  ),
                );
          }
          return Center(child: CircularProgressIndicator());
        }
        ),
      ),
    );
  }
}
