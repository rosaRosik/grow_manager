import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final String url = 'http:///api';

bool switchControl = false;
var textHolder = 'Pompa wyłączona';

Future<bool> controlPump(String status) async {
  final http.Response response = await http.post(url + '/pump/' + status);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

class SwitchWidget extends StatefulWidget {

  @override
  SwitchWidgetClass createState() => new SwitchWidgetClass();
}

class SwitchWidgetClass extends State {
  Future<void> toggleSwitch(bool value) async {

    if(switchControl == false) {
      setState((){
        switchControl = true;
        textHolder = 'Włączanie pompy';
      });

      bool controlPumpResponse = await (controlPump('ON'));
      sleep(const Duration(seconds:3));

      if (controlPumpResponse == false) {
        setState((){
          switchControl = false;
          textHolder = 'Nie można podlać';
        });

      } else {
        setState((){
          switchControl = true;
          textHolder = 'Podlano';
        });
      }
    } else {
      setState((){
        switchControl = false;
        textHolder = 'Pompa wyłączona';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[ Transform.scale(
            scale: 1.5,
            child: Switch(
              onChanged: toggleSwitch,
              value: switchControl,
              activeColor: Colors.blue,
              activeTrackColor: Colors.green,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
            )
        ),

          Text('$textHolder', style: TextStyle(fontSize: 24),)

        ]);
  }
}