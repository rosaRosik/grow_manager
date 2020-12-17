import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Statistic.dart';
import 'SwitchWidget.dart';
import 'main.dart';

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

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {

  Future<Statistic> futureStatistics;

  @override
  void initState() {
    super.initState();
//    _register();
    futureStatistics = fetchStatistics();
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if(mounted) {
        setState(() {
          futureStatistics = fetchStatistics();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Statistic>(
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
                        Image(
                            image: AssetImage('graphics/temp.png'),
                            height: 50,
                            width: 50),
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
                        SizedBox(
                          width: 25,
                          height: 0,
                        ),
                        Image(
                            image: AssetImage('graphics/air.png'),
                            height: 50,
                            width: 50),
                        basicText("  powietrza: "),
                        basicContainerLowPadding(
                            statistic.environmentMoisture.toString() + "%"),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 25,
                          height: 0,
                        ),
                        Image(
                            image: AssetImage('graphics/soil.png'),
                            height: 50,
                            width: 50),
                        basicText(" gleby: "),
                        basicContainerLowPadding(
                            statistic.soilMoisture.toString() + "%"),
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
    );
  }
}
