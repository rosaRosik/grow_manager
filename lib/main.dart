import 'package:flutter/material.dart';
import 'package:growapp/Statistic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

final String url = 'http://localhost/api';

Future<Statistic> fetchStatistics() async {
  final response = await http.get(url+'/statistic');
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

void controlPump(String status) async {
  final http.Response response = await http.post(url + '/pump/'+status);
  if (response.statusCode > 199 && response.statusCode < 300) {
    //TODO: przełączć przycisk + zaktualizwować statusy
  } else {
    throw Exception('Failed to comunicate with pump');
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
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Grow Monitor'),
        ),
        body: Center(

          child: FutureBuilder<Statistic>(

            future: futureStatistics,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var statistic = snapshot.data;
                return Text("Temperatura: " + statistic.temperature.toString() +
                    "\nWilgotność powietrza: " +
                    statistic.environmentMoisture.toString() +
                    "\nWilgotność gleby: " + statistic.soilMoisture.toString());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
          ),
        ),
      ),
    );
  }
}
