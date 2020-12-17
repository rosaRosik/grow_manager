import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';


final String url = 'http://192.168.1.27/api';

class History {
  String name;
  String message;
  String value;
  String date;
  String time;

  History({this.name, this.message, this.value, this.date, this.time});

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
        name: json['name'],
        message: json['message'],
        value: json['value'],
        date: json['date'],
        time: json['time']);
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'message': message,
        'value': value,
        'date': date,
        'time': time,
      };
}

Future<List<History>> fetchHistory(String date) async {
  final response = await http.get(url + '/deviation/' + date);
  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    Iterable list = result;
    return list.map((model) => History.fromJson(model)).toList();
  } else {
    throw Exception('Cannot get data from server');
  }
}

class DeviationPage extends StatefulWidget {

  @override
  _DeviationPageState createState() => _DeviationPageState();
}

class _DeviationPageState extends State<DeviationPage> {

  static final DateTime now = DateTime.now();
  static DateTime date = new DateTime(now.year, now.month, now.day);

  String currentDate = "2020-12-16";
//      "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";


  Future<List<History>> futureHistory;

  @override
  void initState() {
    super.initState();
    futureHistory = fetchHistory(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder < List < History >> (
        future: futureHistory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var resultList = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                History history = snapshot.data[index];
                String specialChar = "%";
                if (history.name == ("Temperatura")) {
                  specialChar = "°C";
                }
                return ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.label_important, color: Colors.red),
                        basicText(history.name + "  " + history.value + specialChar),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        SizedBox(width: 20,),
                        basicLowerText(history.message + "\n" + history.date + " " + history.time),
                      ],
                    ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}