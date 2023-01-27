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

    final SnakeStartBloc ss_bloc_inst =
    siBlocProvider.of<SnakeStartBloc>(context);

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => siBlocProvider<SnakeStartBloc>(
                      bloc: ss_bloc_inst,
                      child:SnakeStart())));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(gss.width * .08),
                    child: Container(
                        color: Colors.white,
                        width: gss.width * .67,
                        height: gss.width * .20,
                        padding: EdgeInsets.all(gss.width * .02),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(gss.width * .08),
                            child: Container(
                              width: gss.width * .64,
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
