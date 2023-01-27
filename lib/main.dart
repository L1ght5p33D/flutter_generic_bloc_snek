import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'snake.dart';
import 'options.dart';
import 'snakeStartBloc.dart';
import 'snekStateBase.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;
import 'package:flutter/services.dart';

// init ss_bloc_inst.sscreen_size to something
// var ss_bloc_inst.sscreen_size = Size(555, 555);

// basically snake game rows * grid height, but used
// for height of explosion align which unfortunately is separate
var snake_game_height = 300.0;

// just init these and set later
double gamescreen_height = 1000.0;
// double gamescreen_width = 890.0;
double touch_control_row_width = 990.0;
double gamespacer_left = 200.0;
double gameboard_width = 444.0;
double touch_button_width = 120.0;

String input_setting = "Touch";

final touch_controller = StreamController<String>();
final step_state_controller = StreamController<bool>();

class CustomError extends StatelessWidget {
  const CustomError({Key key, this.errorDetails}) : super(key: key);

  final FlutterErrorDetails errorDetails;
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
          color: Colors.tealAccent,
          child: Center(
              child: Text(errorDetails.toString(),
                  style: TextStyle(color: Colors.black))))
    ]);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  SnakeStartBloc ss_bloc_inst;
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.
    //   landscapeRight
    //   // DeviceOrientation.portraitUp,
    //   // DeviceOrientation.portraitDown,
    // ]);
    // ss_bloc_inst = snekStateProvider.of(context);
    ss_bloc_inst = SnakeStartBloc();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          errorColor: Colors.tealAccent,
        ),
        builder: (BuildContext context, Widget widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return CustomError(errorDetails: errorDetails);
          };
          return widget;
        },
        home: snekStateProvider<SnakeStartBloc>(
            bloc: ss_bloc_inst, child: SnakeStart()));
  }
}

class SnakeStart extends StatefulWidget {
  @override
  _SnakeStartState createState() {
    return _SnakeStartState();
  }
}

class _SnakeStartState extends State<SnakeStart> {
  SnakeStartBloc ss_bloc_inst;

  TextStyle ui_but_ts = TextStyle(fontSize: 30);
  TextStyle ui_ts_a;
  TextStyle snek_title_style;

  FocusNode kb_fn = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ss_bloc_inst = snekStateProvider.of(context);
      setState(() {
        ss_bloc_inst.sscreen_size = MediaQuery.of(context).size;
      });

      ui_ts_a = TextStyle(
          fontSize: ss_bloc_inst.sscreen_size.width * .033,
          fontFamily: 'MontserratSubrayada');

      snek_title_style = TextStyle(
          fontSize: ss_bloc_inst.sscreen_size.height * .05,
          fontWeight: FontWeight.w700,
          fontFamily: 'MontserratSubrayada');

      if (ss_bloc_inst.update_stream_has_listen == false) {
        ss_bloc_inst.update_stream_has_listen = true;
        print("build stream creating snake state global bloc listener ... ");
        Stream get_b_up_stream = ss_bloc_inst.update_stream;
        get_b_up_stream = ss_bloc_inst.broadcast_update_stream();
        get_b_up_stream.listen((event) {
          // print("braodcast up stream event");
          // print("bup stream event ~ " + event.toString());
          // print("bup get press val ~ " + event["touchinput"]);
          setState(() {
            ss_bloc_inst.sub_val = event["touchinput"];
          });
        });

        // print("Set get up b listener success, ss_bloc_inst state vals ~~ ");
      }
      // print("ss bloc input setting ~ "+ ss_bloc_inst.input_setting.toString());

      // if (ss_bloc_inst.snake_game_timer != null) {
      //   ss_bloc_inst.snake_game_timer.cancel();
      // }

      super.initState();
    });
  }

// had to add this horrible delay to prevent double key press
  bool last_key_press = false;

  key_input_read(String key) {
    print("key_input_read key ::: " + key);
    print("last key press ~ " + last_key_press.toString());

    if (key == "Enter") {}
    if (key == "Arrow Right") {
      if (last_key_press == false) {
        ss_bloc_inst.update_sink.add({"touchinput": "RPress"});
        setState(() {
          last_key_press = true;
        });

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            last_key_press = false;
          });
        });
      }
    }
    if (key == "Arrow Left") {
      if (last_key_press == false) {
        ss_bloc_inst.update_sink.add({"touchinput": "LPress"});
        setState(() {
          last_key_press = true;
        });
        ss_bloc_inst.update_sink.add({"touchinput": "LPress"});

        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            last_key_press = false;
          });
        });
      }
    }
    if (key == "Arrow Up") {}
    if (key == "Arrow Down") {}
    if (key == "Escape") {
      // pause_game();
    }
    if (key == "Tab") {}
  }

  Widget build(BuildContext context) {
    // print("SnakeStart build called, get snakestart bloc inst STATE");

    ss_bloc_inst == null ?? Container();
    ss_bloc_inst.sscreen_size == null ?? Container();

    FocusScope.of(context).requestFocus(kb_fn);

    return Scaffold(
        body: RawKeyboardListener(
            focusNode: kb_fn,
            onKey: (RawKeyEvent rke) {
              String km = rke.physicalKey.toString();
              String kmm = rke.physicalKey.debugName;
              String kmmm = rke.logicalKey.keyLabel;
//          print("keyin data");
//          print(kmmm);
//          print("keyin data 2");
//          print(km);
              print("key in data 3");
              print(kmm);

              if (kmm.contains("Key ")) {
                kmm = kmm.replaceAll("Key ", "");
                print("NEW KMM ::: ");
                print(kmm);
              }
              key_input_read(kmm.toString());
            },
            child: Container(
                width: ss_bloc_inst.sscreen_size.width,
                child: ListView(children: [
                  Center(
                    child: Text(
                      "Flutter Snek",
                      style: snek_title_style,
                    ),
                    // ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ss_bloc_inst.sscreen_size.width * .12),
                      height: ss_bloc_inst.sscreen_size.height * .14,
                      child: GestureDetector(
                          onTap: () {
                            print("log start game vars input setting ::: " +
                                ss_bloc_inst.input_setting);

                            ss_bloc_inst.game_over = false;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      snekStateProvider<SnakeStartBloc>(
                                          bloc: ss_bloc_inst,
                                          child: Snek_si_play())),
                            );
                          },
                          child: Container(
                              width: ss_bloc_inst.sscreen_size.width * .6,
                              height: ss_bloc_inst.sscreen_size.height * .14,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ss_bloc_inst.sscreen_size.width * .08),
                                  child: Container(
                                      color: ss_bloc_inst.g_theme_color,
                                      width:
                                          ss_bloc_inst.sscreen_size.width * .5,
                                      height:
                                          ss_bloc_inst.sscreen_size.width * .14,
                                      padding: EdgeInsets.all(
                                          ss_bloc_inst.sscreen_size.width *
                                              .01),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              ss_bloc_inst.sscreen_size.width *
                                                  .08),
                                          child: Container(
                                            padding: EdgeInsets.all(0.0),
                                            width: ss_bloc_inst
                                                    .sscreen_size.width *
                                                .4,
                                            color: Colors.blueGrey[900],
                                            child: Center(
                                              child: Text(
                                                "Start",
                                                style: ui_but_ts,
                                              ),
                                            ),
                                          ))))))),
                  Container(
                    height: ss_bloc_inst.sscreen_size.width * .06,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ss_bloc_inst.sscreen_size.width * .12),
                      width: ss_bloc_inst.sscreen_size.width,
                      height: ss_bloc_inst.sscreen_size.height * .14,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        snekStateProvider<SnakeStartBloc>(
                                            bloc: ss_bloc_inst,
                                            child: Snek_Options())));
                          },
                          child: Container(
                              width: ss_bloc_inst.sscreen_size.width * .6,
                              height: ss_bloc_inst.sscreen_size.height * .5,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ss_bloc_inst.sscreen_size.width * .08),
                                  child: Container(
                                      color: ss_bloc_inst.g_theme_color,
                                      width:
                                          ss_bloc_inst.sscreen_size.width * .5,
                                      height:
                                          ss_bloc_inst.sscreen_size.width * .14,
                                      padding: EdgeInsets.all(
                                          ss_bloc_inst.sscreen_size.width *
                                              .01),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              ss_bloc_inst.sscreen_size.width *
                                                  .08),
                                          child: Container(
                                            padding: EdgeInsets.all(0.0),
                                            width: ss_bloc_inst
                                                    .sscreen_size.width *
                                                .4,
                                            color: Colors.blueGrey[900],
                                            child: Center(
                                              child: Text(
                                                "Options",
                                                style: ui_but_ts,
                                              ),
                                            ),
                                          ))))))),
                  Container(
                      height: ss_bloc_inst.sscreen_size.height * .3,
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: ss_bloc_inst.sscreen_size.height * .28,
                              child: Center(
                                child: Text(
                                  "Sigma Infinitus",
                                  style: ui_ts_a,
                                ),
                              ),
                            ),
                          ]))
                ]))));
  }
}

class Snek_si_play extends StatefulWidget {
  Snek_si_play({Key key}) : super(key: key);
  _Snek_si_playState createState() => _Snek_si_playState();
}

class _Snek_si_playState extends State<Snek_si_play> {
  var loc_exp_stream;

// local to snek_si_playstate state explosion stream listener
  bool loc_exp_state = false;

  SnakeStartBloc ss_bloc_inst;

  @override
  void initState() {
    super.initState();

    print("snek si play state init state called");

    Future.delayed(Duration.zero, () async {
      ss_bloc_inst = snekStateProvider.of<SnakeStartBloc>(context);
      if (ss_bloc_inst != null) {
        print("pfb has state, set listener");
        if (ss_bloc_inst.exp_stream_has_listen == false) {
          ss_bloc_inst.exp_stream_has_listen = true;
          print("Check state for has listen return False, set Listeners ~~~ ");
          loc_exp_stream = ss_bloc_inst.broadcast_exp_stream();
          // print("loc exp stream ~~" + loc_exp_stream.toString());

          if (loc_exp_stream == "stop stream") {
            print("stop stream");
            // return;
          }

          loc_exp_stream.listen((event) {
            print("exp stream listen event fire ~" + event.toString());

            if (event.toString() == "false") {
              // print("has to parse bool string");
              setState(() {
                loc_exp_state = false;
              });
            } else {
              setState(() {
                loc_exp_state = true;
              });
            }
          });
        }
      }
    });
  }

  dispose() {
    print("dispose snake playstate");
    super.dispose();
    // t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("build play state");
    ss_bloc_inst = snekStateProvider.of<SnakeStartBloc>(context);

// from SnakeBoardPainter .. pass as arg or in state later
    var calccellsize;
    calcCellSize(ss) {
      var cellSize;
      if (ss.width < 950) {
        cellSize = (ss.width / 50) * .96;
      } else {
        cellSize = (950 / 50) * .96;
      }
      return cellSize;
    }

    var gameboardTopPadding = ss_bloc_inst.sscreen_size.width * .01;
    calccellsize = calcCellSize(ss_bloc_inst.sscreen_size);
    gameboard_width = calccellsize * columns;
    gamespacer_left = (ss_bloc_inst.sscreen_size.width -
            gameboard_width -
            (touch_button_width * 2)) /
        2;
    touch_button_width = ss_bloc_inst.sscreen_size.width * .14;

    // gamescreen_width = ss_bloc_inst.sscreen_size.width;
    // gamescreen_height = ss_bloc_inst.sscreen_size.height;
    touch_control_row_width = ss_bloc_inst.sscreen_size.width;
    // var explosion_size = ss_bloc_inst.sscreen_size.height;
    var explosion_size;
    if (ss_bloc_inst.sscreen_size.width > ss_bloc_inst.sscreen_size.height) {
      explosion_size = ss_bloc_inst.sscreen_size.height;
    }
    if (ss_bloc_inst.sscreen_size.width <= ss_bloc_inst.sscreen_size.height) {
      explosion_size = ss_bloc_inst.sscreen_size.width;
    }
    // point 10 = right
    // point 01 = down
    // point -10 = left
    // point 0-1 = up

    var exp_matx = (touch_button_width + gamespacer_left) +
        (ss_bloc_inst.head_pt.x * calccellsize) -
        (explosion_size / 2) +
        calccellsize;

    var exp_maty = (ss_bloc_inst.head_pt.y * calccellsize) +
        calccellsize -
        (explosion_size / 2);

    print("exp matx ~ " + exp_matx.toString());
    print('exp maty ~ ' + exp_maty.toString());

    return Scaffold(
        body: Container(
      padding: EdgeInsets.fromLTRB(0.0, gameboardTopPadding, 0.0, 0.0),
      width: ss_bloc_inst.sscreen_size.width,
      height: ss_bloc_inst.sscreen_size.height,
      color: Colors.blueGrey[900],
      child: Stack(
          // overflow:Overflow.visible,
          // clipBehavior: Clip.none,
          children: [
            Expanded(
              // padding: EdgeInsets.all(ss_bloc_inst.sscreen_size.height * .01),
              // height: ss_bloc_inst.sscreen_size.height,
              // child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         height: gameboard_width,
              // color:Colors.yellow,
              child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(width: touch_button_width + gamespacer_left),
                    // child:
                    snekStateProvider<SnakeStartBloc>(
                        bloc: ss_bloc_inst, child: Snake())
                    // )
                  ]),
            ),
            // ])
            // ),
            loc_exp_state
                ?
                // OverflowBox(
                //    minHeight: ss_bloc_inst.sscreen_size.height ,
                //     minWidth: ss_bloc_inst.sscreen_size.height ,
                //     child:
                // Container(
                //   height: ss_bloc_inst.sscreen_size.height * 2,
                //     width: ss_bloc_inst.sscreen_size.height * 2,
                //     child: Stack(
                //     clipBehavior: Clip.none,
                //     children:[
                Container(
                    transform:
                        Matrix4.translationValues(exp_matx, exp_maty, 0.0),
                    // color: Colors.purple,
                    height: explosion_size,
                    width: explosion_size,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(explosion_size / 2)),
                        child: Opacity(
                            opacity: .3,
                            child: Image.asset(
                              "assets/veil_sn_exp.gif",
                              fit: BoxFit.fill,
                            ))))
                // ]
                // ))
                : Container(),

            ss_bloc_inst.sscreen_size.width > 777
                ? Touch_Control_But()
                : Touch_Control_But_Mob(),
          ]),
    ));
  }
}

class Touch_Control_But extends StatefulWidget {
  Touch_Control_But();

  @override
  _Touch_Control_ButState createState() => _Touch_Control_ButState();
}

class _Touch_Control_ButState extends State<Touch_Control_But> {
  Widget build(BuildContext context) {
    //print("REBUILD TOUCH CONTROL BUT ROW get snake state bloc");
    final SnakeStartBloc ss_bloc_inst =
        snekStateProvider.of<SnakeStartBloc>(context);
    print("set dynamic board size vars 2");

    gamespacer_left = ss_bloc_inst.sscreen_size.width * .2;
    touch_button_width = ss_bloc_inst.sscreen_size.width * .14;
    gameboard_width = ss_bloc_inst.sscreen_size.width * .72;
    // gamescreen_width = ss_bloc_inst.sscreen_size.width * .95;
    touch_control_row_width = ss_bloc_inst.sscreen_size.width;

    return Container(
      width: ss_bloc_inst.sscreen_size.width,
      height: ss_bloc_inst.sscreen_size.height,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
          Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: touch_button_width,
              // color: Colors.teal,
              padding: EdgeInsets.all(6.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      ss_bloc_inst.sscreen_size.width * .03),
                  child:

                      // InkWell(
                      //     splashColor: Colors.tealAccent[700],
                      //     onTap: () {
                      //       // touch_controller.sink.add("LPress");

                      //       ss_bloc_inst.update_sink.add({"touchinput":"LPress"});
                      //       print("LEFT PRESS");
                      //     },

                      GestureDetector(
                          onTap: () {
                            // touch_controller.sink.add("LPress");
                            ss_bloc_inst.update_sink
                                .add({"touchinput": "LPress"});

                            print("LEFT PRESS");
                          },
                          child: ClipRRect(
                              // borderRadius: BorderRadius.circular(ss_bloc_inst.sscreen_size.width * .08),
                              borderRadius: BorderRadius.circular(
                                  ss_bloc_inst.sscreen_size.width * .04),
                              child: Container(
                                  // color:Colors.black12,
                                  color: ss_bloc_inst.g_theme_color,
                                  width: ss_bloc_inst.sscreen_size.width * .2,
                                  // width: ss_bloc_inst.ib_width,
                                  height:
                                      ss_bloc_inst.sscreen_size.height * .63,
                                  padding: EdgeInsets.all(
                                      ss_bloc_inst.sscreen_size.width * .01),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          ss_bloc_inst.sscreen_size.width *
                                              .04),
                                      child: Container(
                                        // width: ss_bloc_inst.sscreen_size.width * .64,
                                        color: Colors.black12,
                                        child: Center(
                                          child: Icon(Icons.chevron_left),
                                        ),
                                      ))))))),
          Container(
              height: ss_bloc_inst.sscreen_size.width * .15,
              padding: EdgeInsets.all(ss_bloc_inst.sscreen_size.width * .02),
              child: Text(ss_bloc_inst.score().toString(),
                  style: TextStyle(
                      fontSize: ss_bloc_inst.sscreen_size.width * .03)))
        ]),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: touch_button_width,
            // color: Colors.teal,
            padding: EdgeInsets.all(6.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    ss_bloc_inst.sscreen_size.width * .03),
                child: GestureDetector(
                    onTap: () {
                      print("RIGHT PRESS EXP");
                      ss_bloc_inst.update_sink.add({"touchinput": "RPress"});
                    },
                    child: ClipRRect(
                        // borderRadius: BorderRadius.circular(ss_bloc_inst.sscreen_size.width * .08),
                        borderRadius: BorderRadius.circular(
                            ss_bloc_inst.sscreen_size.width * .04),
                        child: Container(
                            // color: Colors.black12,
                            color: ss_bloc_inst.g_theme_color,
                            width: ss_bloc_inst.sscreen_size.width * .2,
                            height: ss_bloc_inst.sscreen_size.height * .63,
                            padding: EdgeInsets.all(
                                ss_bloc_inst.sscreen_size.width * .01),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ss_bloc_inst.sscreen_size.width * .04),
                                child: Container(
                                  // width: ss_bloc_inst.sscreen_size.width * .64,
                                  color: Colors.black12,
                                  child: Center(
                                    child: Icon(Icons.chevron_right),
                                  ),
                                )))))),
          ),
          Container(
            height: ss_bloc_inst.sscreen_size.width * .15,
          )
        ])
      ]),
    );
  }
}

class Touch_Control_But_Mob extends StatefulWidget {
  Touch_Control_But_Mob();

  @override
  _Touch_Control_But_Mob_State createState() => _Touch_Control_But_Mob_State();
}

class _Touch_Control_But_Mob_State extends State<Touch_Control_But_Mob> {
  Widget build(BuildContext context) {
    //print("REBUILD TOUCH CONTROL BUT ROW get snake state bloc");
    final SnakeStartBloc ss_bloc_inst =
        snekStateProvider.of<SnakeStartBloc>(context);
    print("set dynamic board size vars 2");

    var touch_button_width = ss_bloc_inst.sscreen_size.width * .44;
    var touch_button_height = ss_bloc_inst.sscreen_size.height * .22;

    return Container(
      width: ss_bloc_inst.sscreen_size.width,
      height: ss_bloc_inst.sscreen_size.height,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
          Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
              height: ss_bloc_inst.sscreen_size.width * .15,
              padding: EdgeInsets.all(ss_bloc_inst.sscreen_size.width * .02),
              child: Text(ss_bloc_inst.score().toString(),
                  style: TextStyle(
                      fontSize: ss_bloc_inst.sscreen_size.width * .03))),
          Container(
              width: touch_button_width,
              height: touch_button_height,
              // color: Colors.teal,
              padding: EdgeInsets.all(6.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      ss_bloc_inst.sscreen_size.width * .03),
                  child:

                      // InkWell(
                      //     splashColor: Colors.tealAccent[700],
                      //     onTap: () {
                      //       // touch_controller.sink.add("LPress");

                      //       ss_bloc_inst.update_sink.add({"touchinput":"LPress"});
                      //       print("LEFT PRESS");
                      //     },

                      GestureDetector(
                          onTap: () {
                            // touch_controller.sink.add("LPress");
                            ss_bloc_inst.update_sink
                                .add({"touchinput": "LPress"});

                            print("LEFT PRESS");
                          },
                          child: ClipRRect(
                              // borderRadius: BorderRadius.circular(ss_bloc_inst.sscreen_size.width * .08),
                              borderRadius: BorderRadius.circular(
                                  ss_bloc_inst.sscreen_size.width * .04),
                              child: Container(
                                  // color:Colors.black12,
                                  color: ss_bloc_inst.g_theme_color,
                                  width: touch_button_width,
                                  height: touch_button_height,
                                  padding: EdgeInsets.all(
                                      ss_bloc_inst.sscreen_size.width * .01),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          ss_bloc_inst.sscreen_size.width *
                                              .04),
                                      child: Container(
                                        // width: ss_bloc_inst.sscreen_size.width * .64,
                                        color: Colors.black12,
                                        child: Center(
                                          child: Icon(Icons.chevron_left),
                                        ),
                                      ))))))),
        ]),
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            width: touch_button_width,
            height: touch_button_height,
            // color: Colors.teal,
            padding: EdgeInsets.all(6.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    ss_bloc_inst.sscreen_size.width * .03),
                child: GestureDetector(
                    onTap: () {
                      print("RIGHT PRESS EXP");
                      ss_bloc_inst.update_sink.add({"touchinput": "RPress"});
                    },
                    child: ClipRRect(
                        // borderRadius: BorderRadius.circular(ss_bloc_inst.sscreen_size.width * .08),
                        borderRadius: BorderRadius.circular(
                            ss_bloc_inst.sscreen_size.width * .04),
                        child: Container(
                            // color: Colors.black12,
                            color: ss_bloc_inst.g_theme_color,
                            width: touch_button_width,
                            height: touch_button_height,
                            padding: EdgeInsets.all(
                                ss_bloc_inst.sscreen_size.width * .01),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ss_bloc_inst.sscreen_size.width * .04),
                                child: Container(
                                  // width: ss_bloc_inst.sscreen_size.width * .64,
                                  color: Colors.black12,
                                  child: Center(
                                    child: Icon(Icons.chevron_right),
                                  ),
                                )))))),
          ),
        ])
      ]),
    );
  }
}
