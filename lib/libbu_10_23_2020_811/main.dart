import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors/sensors.dart';
import 'snake.dart';
import 'options.dart';

var gss =  Size(300,500);
String input_setting = "butt";

TextStyle ui_but_ts = TextStyle(fontSize: gss.width*.05);
TextStyle ui_ts_a = TextStyle(fontSize: gss.width*.033,
    fontFamily: 'MontserratSubrayada');
TextStyle snek_title_style = TextStyle(fontSize: gss.height*.05,
    fontWeight: FontWeight.w700,
    fontFamily: 'MontserratSubrayada'
);

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



  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    gss = MediaQuery.of(context).size;

    return Scaffold(body:
    Container(height:gss.height,
        child:Column(children:[
          Container(
            height: gss.height*.1,
          ),
          Container(height: gss.height*.28,
            child: Center(child: Text("Snek_SI",
              style: snek_title_style,
            ),),
          ),

          Container(
              padding: EdgeInsets.symmetric(horizontal: gss.width*.12),
              width: gss.width,

              child:
              GestureDetector(onTap: (){
                GameState.game_over = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Snek_si_play(input_setting: GameState.input_setting,)
                    )
                );},
                  child:
                  Container(
                      width: gss.width*.6,
                      child:
                      ClipRRect(
                          borderRadius: BorderRadius.circular(gss.width*.08),
                          child:
                          Container(
                              color: GameState.g_theme_color,
                              width: gss.width*.5,
                              height: gss.width *.14,
                              padding: EdgeInsets.all(gss.width*.01),
                              child:
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(gss.width*.08),
                                  child:
                                  Container(
                                    padding: EdgeInsets.all(0.0),
                                    width: gss.width*.4,
                                    color: Colors.blueGrey[900],
                                    child:Center(child: Text("Start", style: ui_but_ts,),),))))
                  ))),
          Container(height: gss.width*.06,),

          Container(
              padding: EdgeInsets.symmetric(horizontal: gss.width*.12),
              width: gss.width,

              child:
              GestureDetector(onTap: (){
                GameState.game_over = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Snek_Options()
                    )
                );},
                  child:
                  Container(
                      width: gss.width*.6,
                      child:
                      ClipRRect(
                          borderRadius: BorderRadius.circular(gss.width*.08),
                          child:
                          Container(
                              color: GameState.g_theme_color,
                              width: gss.width*.5,
                              height: gss.width *.14,
                              padding: EdgeInsets.all(gss.width*.01),
                              child:
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(gss.width*.08),
                                  child:
                                  Container(
                                    padding: EdgeInsets.all(0.0),
                                    width: gss.width*.4,
                                    color: Colors.blueGrey[900],
                                    child:Center(child: Text("Options", style: ui_but_ts,),),))))
                  ))),

          Container(height: gss.height*.1,),
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                Container(height: gss.height*.28,
                  child: Center(child: Text("Sigma Infinitus",
                    style: ui_ts_a,
                  ),),
                ),])
        ]
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
  Snek_si_play({Key key, this.input_setting}) : super(key: key);

  String input_setting;


  _Snek_si_playState createState() => _Snek_si_playState();
}

class _Snek_si_playState extends State<Snek_si_play> {
  static const int _snakeRows = rows;
  static const int _snakeColumns = columns;
  static const double _snakeCellSize = cellSize;
  int snake_length;

  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];


  bool left_press;
  bool right_press;

  double align_exp_x = 0;
  double align_exp_y = 0;

  @override
  Widget build(BuildContext context) {
    if (GameState.game_over == true){
      return Container();
    }
    print(" exp pt :: x: " + GameState.exp_pt.x.toString() + ", y: " + GameState.exp_pt.y.toString());
    print("head point :: x: " + GameState.head_pt.x.toString() + ", y: " + GameState.head_pt.y.toString());

    if (GameState.exp_pt.x > columns/2) {
      align_exp_x =
           -((columns - GameState.exp_pt.x) - (columns / 2)) / (columns / 2);
    }
    if (GameState.exp_pt.x < columns/2) {
      align_exp_x =
          (- 1) * ((columns - GameState.exp_pt.x) - (columns / 2)) / (columns / 2);
    }

    if (GameState.exp_pt.y > columns/2) {
      align_exp_y =
          -((columns - GameState.exp_pt.y) - (columns / 2)) / (columns / 2);
    }
    if (GameState.exp_pt.y < columns/2) {
      align_exp_y =
          -(1) * ((columns - GameState.exp_pt.y) - (columns / 2)) / (columns / 2);
    }

    print("calculated align vals ::: ");
    print(align_exp_x.toString());
    print(align_exp_y.toString());

    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();

    reset_press(){
      setState(() {
        left_press = false;
        right_press = false;
      });
    }

    set_button_state(lp,rp){
      setState(() {
        left_press = lp;
        right_press = rp;
      });
    }

    return
      // WillPopScope(
      //     onWillPop: ()async{
      //       GameState.reset_game();
      //       Navigator.pushReplacement(context,
      //           MaterialPageRoute(builder: (context) =>
      //               Snek_si_play()
      //           )
      //       );   return true;       },
      //     child:
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // title: const Center(child:Text('Snek_SI')),
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
                      child: Stack(children:[
                        /// control pos explosion
                        // Container(
                        //   width: gss.width,
                        //   height: gss.height,
                        //   child:  Container(
                        //     // width: gss.width *.4,
                        //     // height: gss.width * .4,
                        //       child:Align(
                        //           alignment: Alignment(
                        //              .2,
                        //               .6
                        //           ),
                        //           // GameState.exp_pt.x.toDouble() / 2,
                        //           // GameState.exp_pt.y.toDouble()),
                        //           child: Container(
                        //               width: gss.width *.033,
                        //               height: gss.width * .033,
                        //               child:
                        //               Image.asset(
                        //                 "assets/frag_exp_.gif",
                        //                 fit: BoxFit.contain,
                        //               )))),
                        // ),
                        GameState.show_food_exp?
                        Container(
                          width: gss.width,
                          height: gss.height,
                          child:  Container(
                            // width: gss.width *.4,
                            // height: gss.width * .4,
                              child:Align(
                                  alignment: Alignment(
                                      align_exp_x,
                                      align_exp_y
                                  ),
                                  // GameState.exp_pt.x.toDouble() / 2,
                                  // GameState.exp_pt.y.toDouble()),
                                  child: Container(
                                      width: gss.width *.033,
                                      height: gss.width * .033,
                                      child:
                                      Image.asset(
                                        "assets/veil_sn_exp.gif",
                                        fit: BoxFit.contain,
                                      )))),
                        ):Container(),
                        Snake(
                          // rows: _snakeRows,
                          // columns: _snakeColumns,
                          // cellSize: _snakeCellSize,
                          input_setting: widget.input_setting,
                          right_press: right_press,
                          left_press: left_press,
                          reset_press: reset_press,
                        )]),
                    ),
                  ),
                ),

                Touch_Control_But(input_setting: widget.input_setting,
                set_button_state:set_button_state
                ),
                Container(
                  // height: gss.height*.2,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Score: ${GameState.snakeLength -5}",
                            style: ui_ts_a,
                          )
                        ])),
                Container(height: gss.height*.06,)
              ],
            ),
          );
    // );
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


class Touch_Control_But extends StatelessWidget {
  Touch_Control_But({Key key, this.input_setting, this.set_button_state }):super(key:key);
  final String input_setting;
  final Function set_button_state;

  Widget build(BuildContext context) {
    if (input_setting == "Touch"){
    return Container(
      // height: gss.height*.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
      ClipRRect(
      borderRadius: BorderRadius.circular(gss.width*.08),
      child:
          InkWell(
            splashColor: Colors.tealAccent[700],
              onTap: (){
    set_button_state(true,false);
              },
          //     child:
          // GestureDetector(
          //     onTap: (){
          //       print("Left Press");
          //       // setState(() {
          //       //   left_press = true;
          //       //   right_press = false;
          //       // });
          //     set_button_state(true,false);
          //     },
              child:
              ClipRRect(
                  borderRadius: BorderRadius.circular(gss.width*.08),
                  child:
                  Container(
                      color: GameState.g_theme_color,
                      width: gss.width*.26,
                      height: gss.width * .20,
                      padding: EdgeInsets.all(gss.width*.02),
                      child:
                      ClipRRect(
                          borderRadius: BorderRadius.circular(gss.width*.08),
                          child:
                          Container(
                            width: gss.width*.64,
                            color: Colors.blueGrey[900],
                            child:Center(child: Icon(Icons.chevron_left),),)))))),
    // ),
    //       GestureDetector(
    //           onTap: (){
    //             print("Right press");
    //             // setState(() {/
    //             //   right_press = true;
    //             //   left_press = false;
    //             // });
    //           set_button_state(false,true);
    //           },
    //           child:
      ClipRRect(
        borderRadius: BorderRadius.circular(gss.width*.06),
        child:InkWell(
              splashColor: Colors.tealAccent[700],
              onTap: (){
                set_button_state(false,true);
              },child:
              ClipRRect(
                  borderRadius: BorderRadius.circular(gss.width*.08),
                  child:
                  Container(
                      color: GameState.g_theme_color,
                      width: gss.width*.26,
                      height: gss.width * .20,
                      padding: EdgeInsets.all(gss.width*.02),
                      child:
                      ClipRRect(
                          borderRadius: BorderRadius.circular(gss.width*.08),
                          child:
                          Container(
                            width: gss.width*.64,
                            color: Colors.blueGrey[900],
                            child:Center(child: Icon(Icons.chevron_right),),)))))),


        ],),
    );
  }else{return Container();}
}
}
