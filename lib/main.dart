import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import 'snake.dart';

var gss =  Size(300,500);
TextStyle ui_but_ts = TextStyle(fontSize: gss.width*.09);
void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class SnakeStart extends StatefulWidget {
  @override
  _SnakeStartState createState() => _SnakeStartState();
}

class _SnakeStartState extends State<SnakeStart> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    gss = MediaQuery.of(context).size;

    return Scaffold(body:

    Center(child:
      GestureDetector(onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            Snek_si_play()
      )
      );},
        child:
            ClipRRect(
                borderRadius: BorderRadius.circular(gss.width*.08),
                child:
            Container(
              color: Colors.white,
              width: gss.width*.66,
                height: gss.width *.14,
                padding: EdgeInsets.all(gss.width*.02),
                child:
    ClipRRect(
    borderRadius: BorderRadius.circular(gss.width*.08),
    child:
        Container(
          width: gss.width*.64,
          color: Colors.blueGrey[900],
          child:Center(child: Text("start", style: ui_but_ts,),),))))
      )));
}}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snek_si',
      theme: ThemeData(
        // primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark
      ),
      home: SnakeStart()
    );
  }
}

class Snek_si_play extends StatefulWidget {
  Snek_si_play({Key key}) : super(key: key);

  _Snek_si_playState createState() => _Snek_si_playState();
}

class _Snek_si_playState extends State<Snek_si_play> {
  static const int _snakeRows = 40;
  static const int _snakeColumns = 40;
  static const double _snakeCellSize = 10.0;

  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();

    print("len user acc vals ::: ");
    print(_userAccelerometerValues.length.toString());

    return
      WillPopScope(
          onWillPop: ()async{
            snake_game_timer.cancel();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>
                    Snek_si_play()
                )
            );   return true;       },
          child:
      Scaffold(
      appBar: AppBar(

        title: const Center(child:Text('Snek_si')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.white),
              ),
              child: SizedBox(
                height: _snakeRows * _snakeCellSize,
                width: _snakeColumns * _snakeCellSize,
                child: Snake(
                  rows: _snakeRows,
                  columns: _snakeColumns,
                  cellSize: _snakeCellSize,
                ),
              ),
            ),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Accelerometer: $accelerometer'),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('UserAccelerometer: $userAccelerometer'),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Gyroscope: $gyroscope'),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }
}