import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'snake.dart';
import 'dart:async';
import 'dart:io';
import 'main.dart';
import 'snakeStartBloc.dart';
import 'snekStateBase.dart';

class SnekScore extends StatefulWidget {
  SnekScore(this.final_score);
  int final_score;
  _SnekScoreState createState() => _SnekScoreState();
}

class _SnekScoreState extends State<SnekScore> {
  @override
  Widget build(BuildContext context) {
    SnakeStartBloc ss_bloc_inst = snekStateProvider.of(context);
    TextStyle snek_title_style = TextStyle(
        fontSize: ss_bloc_inst.sscreen_size.height * .05,
        fontWeight: FontWeight.w700,
        fontFamily: 'MontserratSubrayada');
    TextStyle ui_but_ts = TextStyle(fontSize: 30);
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: ss_bloc_inst.sscreen_size.height * .1,
            ),
            Text("Game Over", style: snek_title_style),
            Container(
              height: ss_bloc_inst.sscreen_size.height * .1,
            ),
            Text(
              "Final Score: " + widget.final_score.toString(),
              style: ui_but_ts,
            ),
            Container(
              height: ss_bloc_inst.sscreen_size.height * .06,
            ),
            GestureDetector(
                onTap: () {
                  print("play again tap ");

                  ss_bloc_inst.dispose();
                  ss_bloc_inst = SnakeStartBloc();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MaterialApp(
                              debugShowCheckedModeBanner: false,
                              theme: ThemeData(brightness: Brightness.dark),
                              home:
                                  // First instance of snakeStartBloc, need to listen to update_stream
                                  snekStateProvider<SnakeStartBloc>(
                                      bloc: ss_bloc_inst,
                                      child: SnakeStart()))));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(ss_bloc_inst.sscreen_size.width * .08),
                    child: Container(
                        color: Colors.white,
                        // width: ss_bloc_inst.sscreen_size.width * .65,
                        // height: ss_bloc_inst.sscreen_size.width * .17,
                        padding: EdgeInsets.all(ss_bloc_inst.sscreen_size.width * .01),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(ss_bloc_inst.sscreen_size.width * .08),
                            child: Container(
                              height: ss_bloc_inst.sscreen_size.width * .19,
                              width: ss_bloc_inst.sscreen_size.width * .66,
                              color: Colors.blueGrey[900],
                              child: Center(
                                  child: Text(
                                "Play Again",
                                style: ui_but_ts,
                              )),
                            ))))),
          ],
        ),
      ),
    );
  }
}
