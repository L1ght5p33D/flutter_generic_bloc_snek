import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'dart:ui';

class KB_Listener extends StatefulWidget {
  const KB_Listener({ Key? key }) : super(key: key);

  @override
  _KB_ListenerState createState() => _KB_ListenerState();
}

class _KB_ListenerState extends State<KB_Listener> {

    key_input_read(String key){
    print("key_input_read key ::: " + key);
    var timer = Timer(Duration(seconds: 1), () => print('done'));

    var key_input_q;
    var vx;
  
    timer.cancel();

    if(key == "Enter"){
      key_input_q = "";
    }
    if (key == "Arrow Right"){
      setState(() {
        vx = 1;
      });
    }
    if (key == "Arrow Left"){
      setState(() {
        vx = -1;
      });
    }
    if (key == "Arrow Up"){}
    if (key == "Arrow Down"){}
    if (key == "Escape"){
      // pause_game();
    }
    if (key == "Tab"){}
    else{
      print("setting not last state");
      setState(() {
        key_input_q += key;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}


