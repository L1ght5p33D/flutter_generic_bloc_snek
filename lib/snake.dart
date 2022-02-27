import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'main.dart';

Timer snake_game_timer;

math.Random random = math.Random();

class Snake extends StatefulWidget {
  Snake({this.rows = 40,
    this.columns = 40,
    this.cellSize = 10.0,
    this.snake_length,
  this.input_setting,
  this.left_press,
  this.right_press,
  this.reset_press}) {
    assert(10 <= rows);
    assert(10 <= columns);
    assert(5.0 <= cellSize);
  }

  final int rows;
  final int columns;
  final double cellSize;
  final int snake_length;
  final String input_setting;
  bool left_press;
  bool right_press;
  Function reset_press;

  @override
  State<StatefulWidget> createState() => SnakeState(
      rows, columns, cellSize, input_setting,
  left_press,
    right_press,
    reset_press
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
      this.reset_press
      ) {
    state = GameState(rows, columns);
  }

  String input_setting;
bool left_press;
bool right_press;
Function reset_press;

bool state_left;
bool state_right;


  double cellSize;
  GameState state;
  AccelerometerEvent acceleration;
  StreamSubscription<AccelerometerEvent> _streamSubscription;


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

    snake_game_timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
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
    GameState.head_pt.x == state.columns -1  ||
        GameState.head_pt.y == state.rows-1

    ){
      print("GAMEEEOVERRRR");

      GameState.reset_game();

      snake_game_timer.cancel();

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              SnakeStart()
          )
      );

    }
  }
}

class GameState {
  GameState(this.rows, this.columns) {
    int snakeLength=5;
  }

  static int step_count = 0;
  int rows;
  int columns;
  static int snakeLength=5;

  static math.Point food_pt = math.Point(0,0);
  static math.Point head_pt = math.Point(0,0);

  static List<math.Point<int>> body = <math.Point<int>>[const math.Point<int>(0, 0)];
  static math.Point<int> direction = const math.Point<int>(1, 0);

  static void reset_game(){
    step_count = 0;
    snakeLength = 5;
    food_pt = math.Point(0,0);
    head_pt = math.Point(0,0);
   body = <math.Point<int>>[const math.Point<int>(0, 0)];
    direction = const math.Point<int>(1, 0);
  }

  void reset_food(){
    int food_pt_x = random.nextInt(columns);
    int food_pt_y = random.nextInt(rows);
    print("x: " + food_pt_x.toString() + " y: " + food_pt_y.toString());
    food_pt = math.Point(food_pt_x, food_pt_y);
  }

  void step(math.Point<int> newDirection) {


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
      print("GOT FOOD WINRAR");
      snakeLength +=1;
      reset_food();
    }
    step_count += 1;
  }
}