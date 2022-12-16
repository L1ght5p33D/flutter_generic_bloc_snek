import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'snake.dart';
import 'options.dart';
import 'snakeStartBloc.dart';
import 'siBlocBase.dart';
import 'dart:convert';
import 'dart:math' as math;

// init gss to something
var gss = Size(555, 555);

// basically snake game rows * grid height, but used
// for height of explosion align which unfortunately is separate
var snake_game_height = 300.0;

// just init these and set later
double gamescreen_height = 1000.0;
double gamescreen_width = 890.0;
double touch_control_row_width = 990.0;
double gamespacer_left = 200.0;
double gameboard_width = 444.0;
double touch_button_width = 120.0;

String input_setting = "Touch";

TextStyle ui_but_ts = TextStyle(fontSize: 30);
TextStyle ui_ts_a =
    TextStyle(fontSize: gss.width * .033, fontFamily: 'MontserratSubrayada');
TextStyle snek_title_style = TextStyle(
    fontSize: gss.height * .05,
    fontWeight: FontWeight.w700,
    fontFamily: 'MontserratSubrayada');

final touch_controller = StreamController<String>();
final step_state_controller = StreamController<bool>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static SnakeStartBloc g_ss_b = SnakeStartBloc();

  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.
    //   landscapeRight
    //   // DeviceOrientation.portraitUp,
    //   // DeviceOrientation.portraitDown,
    // ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark),
        home: SnakeStart());
  }
}

class SnakeStart extends StatefulWidget {
  @override
  _SnakeStartState createState() {
    return _SnakeStartState();
  }
}

class _SnakeStartState extends State<SnakeStart> {
  Widget build(BuildContext context) {
    print("SnakeStart build called, get snakestart bloc inst STATE");

// Init new Bloc here
    SnakeStartBloc ss_bloc_inst = SnakeStartBloc();

    ss_bloc_inst.sscreen_size = MediaQuery.of(context).size;

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
    gss = MediaQuery.of(context).size;
    // print("GSS width ~ " + gss.width.toString());

    if (ss_bloc_inst.snake_game_timer != null) {
      ss_bloc_inst.snake_game_timer.cancel();
    }

    return Scaffold(
        body: Container(
            width: gss.width,
            child: ListView(children: [
              Center(
                child: Text(
                  "Snek_303",
                  style: snek_title_style,
                ),
                // ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: gss.width * .12),
                  height: gss.height * .3,
                  child: GestureDetector(
                      onTap: () {
                        print("log start game vars input setting ::: " +
                            ss_bloc_inst.input_setting);

                        ss_bloc_inst.game_over = false;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  siBlocProvider<SnakeStartBloc>(
                                      bloc: ss_bloc_inst,
                                      child: Snek_si_play())),
                        );
                      },
                      child: Container(
                          width: gss.width * .6,
                          height: gss.height * .3,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(gss.width * .08),
                              child: Container(
                                  color: ss_bloc_inst.g_theme_color,
                                  width: gss.width * .5,
                                  height: gss.width * .14,
                                  padding: EdgeInsets.all(gss.width * .01),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          gss.width * .08),
                                      child: Container(
                                        padding: EdgeInsets.all(0.0),
                                        width: gss.width * .4,
                                        color: Colors.blueGrey[900],
                                        child: Center(
                                          child: Text(
                                            "Start",
                                            style: ui_but_ts,
                                          ),
                                        ),
                                      ))))))),
              Container(
                height: gss.width * .06,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: gss.width * .12),
                  width: gss.width,
                  height: gss.height * .3,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    siBlocProvider<SnakeStartBloc>(
                                        bloc: ss_bloc_inst,
                                        child: Snek_Options())));
                      },
                      child: Container(
                          width: gss.width * .6,
                          height: gss.height * .5,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(gss.width * .08),
                              child: Container(
                                  color: ss_bloc_inst.g_theme_color,
                                  width: gss.width * .5,
                                  height: gss.width * .14,
                                  padding: EdgeInsets.all(gss.width * .01),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          gss.width * .08),
                                      child: Container(
                                        padding: EdgeInsets.all(0.0),
                                        width: gss.width * .4,
                                        color: Colors.blueGrey[900],
                                        child: Center(
                                          child: Text(
                                            "Options",
                                            style: ui_but_ts,
                                          ),
                                        ),
                                      ))))))),
              Container(
                  height: gss.height * .3,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: gss.height * .28,
                          child: Center(
                            child: Text(
                              "Sigma Infinitus",
                              style: ui_ts_a,
                            ),
                          ),
                        ),
                      ]))
            ])));
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

    ss_bloc_inst = siBlocProvider.of<SnakeStartBloc>(context);
    if (ss_bloc_inst != null) {
      print("pfb has state, set listener");
      if (ss_bloc_inst.exp_stream_has_listen == false) {
        ss_bloc_inst.exp_stream_has_listen = true;
        print("Check state for has listen return False, set Listeners ~~~ ");
        loc_exp_stream = ss_bloc_inst.broadcast_exp_stream();
        // print("loc exp stream ~~" + loc_exp_stream.toString());

        if (loc_exp_stream == "stop stream") {
          print("stop stream");
          return;
        }

        loc_exp_stream.listen((event) {
          // print("exp stream listen event fire ~" + event.toString());

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
  }

  dispose() {
    print("dispose snake playstate");
    super.dispose();
    // t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (loc_exp_stream == null) {
      print("set loc exp listen in build");
      ss_bloc_inst.exp_stream.asBroadcastStream().listen((event) {
        print("EXP LISTENER FIRED");
        var exp_event = false;
        if (event.toString() == "true") {
          exp_event = true;
        }
        setState(() {
          loc_exp_state = exp_event;
        });
      });
    }
    loc_exp_state = ss_bloc_inst.show_food_exp;

// var test_head_pt_x = 15;
// var test_head_pt_x = 30;
// var test_head_pt_y = 15;
// var test_head_pt_y = 30;

// print("gamescreenwidth val ~ " + gameboard_width.toString());
// top left
// var exp_matx = - (1.88 * gamescreen_width) +  (1.55 * gamescreen_width);

    var exp_matx = -(1.88 * gamescreen_width) +
        (1.55 * gamescreen_width) +
// + (( gamescreen_width /48 ) *test_head_pt_x );
        ((gamescreen_width / 48) * ss_bloc_inst.head_pt.x);

// top
// var exp_maty = -300.0;
// var exp_maty = 100.0;

    print("screen width " + ss_bloc_inst.sscreen_size.width.toString());

    var exp_maty = -300 +
        .9 * (gameboard_width / 400) * (ss_bloc_inst.head_pt.y * (400 / 32));

    gamespacer_left = ss_bloc_inst.sscreen_size.width * .2;
    gameboard_width = ss_bloc_inst.sscreen_size.width * .72;
    gamescreen_width = ss_bloc_inst.sscreen_size.width;
    gamescreen_height = ss_bloc_inst.sscreen_size.height;
    touch_control_row_width = ss_bloc_inst.sscreen_size.width;
    touch_button_width = ss_bloc_inst.sscreen_size.width * .14;

    return Scaffold(
        body: Container(
      padding: EdgeInsets.zero,
      width: ss_bloc_inst.sscreen_size.width,
      height: ss_bloc_inst.sscreen_size.height,
      color: Colors.blueGrey[900],
      child: Stack(
          // overflow:Overflow.visible,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(ss_bloc_inst.sscreen_size.height * .01),
              height: ss_bloc_inst.sscreen_size.height,
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
                    Container(width: touch_button_width * 1.3),
                    siBlocProvider<SnakeStartBloc>(
                      bloc: ss_bloc_inst,
                      child: Snake(),
                    )
                  ]),
            ),
            // ])
            // ),
            loc_exp_state
                ?
                // ? OverflowBox(
                //     minHeight: ss_bloc_inst.sscreen_size.height,
                //     child:
                Container(
                    transform:
                        Matrix4.translationValues(exp_matx, exp_maty, 0.0),
                    // color: Colors.purple,
                    height: ss_bloc_inst.sscreen_size.height,
                    width: gameboard_width * 2,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(
                            ss_bloc_inst.sscreen_size.width / 3)),
                        child: Opacity(
                            opacity: .15,
                            child: Image.asset(
                              "assets/veil_sn_exp.gif",
                              fit: BoxFit.cover,
                            ))))
                : Container(),
            Touch_Control_But(),
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
        siBlocProvider.of<SnakeStartBloc>(context);
    print("set dynamic board size vars 2");
    gamespacer_left = ss_bloc_inst.sscreen_size.width * .2;
    gameboard_width = ss_bloc_inst.sscreen_size.width * .72;
    gamescreen_width = ss_bloc_inst.sscreen_size.width * .95;
    touch_control_row_width = ss_bloc_inst.sscreen_size.width;
    touch_button_width = ss_bloc_inst.sscreen_size.width * .14;

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
                  borderRadius: BorderRadius.circular(gss.width * .03),
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
                              // borderRadius: BorderRadius.circular(gss.width * .08),
                              borderRadius:
                                  BorderRadius.circular(gss.width * .04),
                              child: Container(
                                  // color:Colors.black12,
                                  // color: ss_bloc_inst.g_theme_color,
                                  width: gss.width * .2,
                                  // width: ss_bloc_inst.ib_width,
                                  height: gss.height * .63,
                                  padding: EdgeInsets.all(gss.width * .01),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          gss.width * .04),
                                      child: Container(
                                        // width: gss.width * .64,
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
                borderRadius: BorderRadius.circular(gss.width * .03),
                child: GestureDetector(
                    onTap: () {
                      print("RIGHT PRESS EXP");
                      ss_bloc_inst.update_sink.add({"touchinput": "RPress"});

                      // touch_controller.sink.add("RPress");
                    },
                    child: ClipRRect(
                        // borderRadius: BorderRadius.circular(gss.width * .08),
                        borderRadius: BorderRadius.circular(gss.width * .04),
                        child: Container(
                            color: Colors.black12,
                            // color: ss_bloc_inst.g_theme_color,
                            width: gss.width * .2,
                            height: gss.height * .63,
                            padding: EdgeInsets.all(gss.width * .01),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(gss.width * .04),
                                child: Container(
                                  // width: gss.width * .64,
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
