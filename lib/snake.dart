import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'main.dart';

Timer snake_game_timer;
StreamSubscription<AccelerometerEvent> _streamSubscription;


math.Random random = math.Random();
const int rows = 30;
const int columns = 30;
const double cellSize = 10.0;
class Snake extends StatefulWidget {
  Snake({
    // this.rows = 40,
    // this.columns = 40,
    // this.cellSize = 10.0,
    this.snake_length,
    this.input_setting,
    this.left_press,
    this.right_press,
    this.show_food_exp,
    this.reset_press}) {
    assert(10 <= rows);
    assert(10 <= columns);
    assert(5.0 <= cellSize);
  }

  // final int rows;
  // final int columns;
  // final double cellSize;
  final int snake_length;
  final String input_setting;
  bool left_press;
  bool right_press;
  bool show_food_exp;
  Function reset_press;


  State<StatefulWidget> createState() => SnakeState(
    rows, columns, cellSize,
    input_setting,
    left_press,
    right_press,
    show_food_exp,
    reset_press,
  );
}

class SnakeBoardPainter extends CustomPainter {
  SnakeBoardPainter(this.state, this.cellSize);

  GameState state;
  double cellSize;

  void paint(Canvas canvas, Size size) {
    final Paint blackLine = Paint()..color = Colors.deepPurple;
    final Paint blackFilled = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, size.bottomLeft(Offset.zero)),
      blackLine,
    );

    /// Draw snek body from state.body
    for (math.Point<int> p in GameState.body) {
      final Offset a = Offset(cellSize * p.x, cellSize * p.y);
      final Offset b = Offset(cellSize * (p.x + 1), cellSize * (p.y + 1));

      canvas.drawRect(Rect.fromPoints(a, b), blackFilled);
    }

    /// Draw food if it needs
    if(GameState.food_pt.x != 0 ) {
      final Offset a =
      Offset(cellSize * GameState.food_pt.x,
          cellSize * GameState.food_pt.y);

      final Offset b = Offset(cellSize * (GameState.food_pt.x + 1),
          cellSize * (GameState.food_pt.y + 1));

      canvas.drawRect(Rect.fromPoints(a, b), blackFilled);
    }
  }


  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}



class SnakeState extends State<Snake> {
  SnakeState(int rows, int columns,
      this.cellSize,
      this.input_setting,
      this.left_press,
      this.right_press,
      this.show_food_exp,
      this.reset_press
      ) {
    state = GameState();
  }

  String input_setting;
  bool left_press;
  bool right_press;
  bool show_food_exp;
  Function reset_press;

  bool state_left;
  bool state_right;


  double cellSize;
  GameState state;
  AccelerometerEvent acceleration;
  // StreamSubscription<AccelerometerEvent> _streamSubscription;


  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: SnakeBoardPainter(state, cellSize));
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    snake_game_timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
          setState(() {
            acceleration = event;
          });
        });

    snake_game_timer = Timer.periodic( Duration(milliseconds: 234), (_) {
      setState(() {
        _step();
      });
    });

    state_left = false;
    state_right = false;

  }




  math.Point oldDirection;
  math.Point<int> newDirection;

  void _step() {
    print("step inpu tsetting :: " + input_setting.toString());
    state_left = false;
    state_right = false;

    if (widget.right_press == true){
      state_right = true;
    }
    if (widget.left_press == true){
      state_left = true;
    }

    if (input_setting == "Tilt"){
      newDirection = acceleration == null
          ? null
          : acceleration.x.abs() < 1.0 && acceleration.y.abs() < 1.0
          ? null
          : (acceleration.x.abs() < acceleration.y.abs())
          ? math.Point<int>(0, acceleration.y.sign.toInt())
          : math.Point<int>(-acceleration.x.sign.toInt(), 0);
    }

    ///#################################3
    if (input_setting == "Touch"){
      if (state_left == true) {
        print("state right true set");
        newDirection = oldDirection == null ? math.Point(0, 1) :
        oldDirection == math.Point(-1, 0) ? math.Point(0, 1) :
        oldDirection == math.Point(0, 1) ? math.Point(1, 0) :
        oldDirection == math.Point(1, 0) ? math.Point(0, -1) :
        oldDirection == math.Point(0, -1) ? math.Point(-1, 0) : math.Point(0, 1);
      }
      else if (state_right == true) {
        print("State left true set");
        newDirection = oldDirection == null ? math.Point(0, 1) :
        oldDirection == math.Point(-1, 0) ? math.Point(0, -1) :
        oldDirection == math.Point(0, 1) ? math.Point(-1, 0) :
        oldDirection == math.Point(1, 0) ? math.Point(0, 1) :
        oldDirection == math.Point(0, -1) ? math.Point(1, 0) : math.Point(
            0, 1);
      }
      else if (state_right == false &&
          state_left == false) {
        newDirection = oldDirection == null ? math.Point(0, 1) : oldDirection;
      }
    }

    state_right = false;
    state_left = false;
    widget.right_press = false;
    widget.left_press = false;
    reset_press();

    oldDirection = newDirection;

    state.step(newDirection);

    print("state step");
    print(GameState.head_pt.x.toString());
    print(GameState.head_pt.y.toString());
    if (
    // state.head_pt.x < 0 ||
    // state.head_pt.y < 0 ||
    GameState.head_pt.x == columns -1  ||
        GameState.head_pt.y == rows-1

    ){
      print("GAMEEEOVERRRR");
      GameState.reset_game();

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              SnekScore(GameState.score())
          )
      );
    }
    if (GameState.head_pt.x == GameState.food_pt.x &&
        GameState.head_pt.y == GameState.food_pt.y
    ){
      print("Food winrar from step");
      snake_game_timer.cancel();
      snake_game_timer = Timer.periodic( Duration(milliseconds: 234 - (GameState.foods_captured * 100)), (_) {
        setState(() {
          _step();
        });
      });
    }

  }
}

class GameState {
  GameState() {
    int snakeLength=5;
  }
static int score(){
    return (step_count + foods_captured * 100);
}
  static int step_count = 0;
static int foods_captured=0;
  int show_food_exp_step=0;

  // int rows;
  // int columns;
  static int snakeLength=5;

  static bool show_food_exp = false;

  static math.Point food_pt = math.Point(0,0);
  static math.Point head_pt = math.Point(0,0);
  static math.Point exp_pt = math.Point(0,0);

  static List<math.Point<int>> body = <math.Point<int>>[const math.Point<int>(0, 0)];
  static math.Point<int> direction = const math.Point<int>(1, 0);

  static void reset_game(){
    step_count = 0;
    snakeLength = 5;
    food_pt = math.Point(0,0);
    head_pt = math.Point(0,0);
    body = <math.Point<int>>[const math.Point<int>(0, 0)];
    direction = const math.Point<int>(1, 0);
    snake_game_timer.cancel();
    _streamSubscription.cancel();
  }

  void reset_food(){
    int food_pt_x = random.nextInt(columns);
    int food_pt_y = random.nextInt(rows);
    print("x: " + food_pt_x.toString() + " y: " + food_pt_y.toString());
    food_pt = math.Point(food_pt_x, food_pt_y);
  }

  void step(math.Point<int> newDirection) {

    print("step head pos ::: " + head_pt.x.toString() + ", " + head_pt.y.toString());
    print("step food pos ::: " + food_pt.x.toString() + ", " + food_pt.y.toString());
    print("step exp pos ::: " + exp_pt.x.toString() + ", " + exp_pt.y.toString());

    /// wait ten steps after showing explosion to turn off
    if (step_count - show_food_exp_step > 15){
      show_food_exp = false;
    }

    math.Point<int> next = body.last + direction;
    next = math.Point<int>(next.x % columns, next.y % rows);
    head_pt = math.Point(next.x,next.y);
    body.add(next);
    if (body.length > snakeLength) body.removeAt(0);
    direction = newDirection ?? direction;

    if (step_count % 251 == 0 ){
      print("food set:: ");
      reset_food();
    }

    if (head_pt.x == food_pt.x &&
        head_pt.y == food_pt.y
    ){

      show_food_exp = true;
      foods_captured +=1;
      exp_pt = head_pt;
      show_food_exp_step = step_count;

      print("GOT FOOD WINRAR");
      snakeLength +=1;
      reset_food();
    }
    step_count += 1;
  }
}

class SnekScore extends StatefulWidget {
  SnekScore(this.final_score);
  int final_score;
  _SnekScoreState createState() => _SnekScoreState();
}

class _SnekScoreState extends State<SnekScore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child:
      Column(children: <Widget>[
        Container(height: gss.height*.1,),
        Text("Game Over", style: snek_title_style),
        Container(height: gss.height*.1,),
        Text("Final Score: " + widget.final_score.toString(),style: ui_but_ts,),
        Container(height: gss.height*.06,),
        GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      SnakeStart()
                  )
              );
            },
            child:
            ClipRRect(
                borderRadius: BorderRadius.circular(gss.width*.08),
                child:
                Container(
                    color: Colors.white,
                    width: gss.width*.67,
                    height: gss.width * .20,
                    padding: EdgeInsets.all(gss.width*.02),
                    child:
                    ClipRRect(
                        borderRadius: BorderRadius.circular(gss.width*.08),
                        child:
                        Container(
                          width: gss.width*.64,
                          color: Colors.blueGrey[900],
                          child:Center(child:Text("Play Again",style: ui_but_ts,)),))))),

      ],),),);
  }
}
