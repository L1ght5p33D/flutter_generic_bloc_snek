import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'snake.dart';
import 'dart:async';
import 'dart:io';
import 'main.dart';
import 'snakeStartBloc.dart';
import 'siBlocBase.dart';

class SnekScore extends StatefulWidget {
  SnekScore(this.final_score);
  int final_score;
  _SnekScoreState createState() => _SnekScoreState();
}

class _SnekScoreState extends State<SnekScore> {
  @override
  Widget build(BuildContext context) {
    SnakeStartBloc ss_bloc_inst = siBlocProvider.of<SnakeStartBloc>(context);

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: gss.height * .1,
            ),
            Text("Game Over", style: snek_title_style),
            Container(
              height: gss.height * .1,
            ),
            Text(
              "Final Score: " + widget.final_score.toString(),
              style: ui_but_ts,
            ),
            Container(
              height: gss.height * .06,
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
                                  siBlocProvider<SnakeStartBloc>(
                                      bloc: ss_bloc_inst,
                                      child: SnakeStart()))));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(gss.width * .08),
                    child: Container(
                        color: Colors.white,
                        // width: gss.width * .65,
                        // height: gss.width * .17,
                        padding: EdgeInsets.all(gss.width * .01),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(gss.width * .08),
                            child: Container(
                              height: gss.width * .19,
                              width: gss.width * .66,
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
