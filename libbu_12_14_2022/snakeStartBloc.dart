import 'package:flutter/material.dart';
import 'siBlocBase.dart';
import 'dart:async';
import 'dart:math' as math;
import 'snake.dart';

// steps before food resets
int food_reset_interval = 88;
int snake_length = 5;

class SnakeStartBloc implements siBlocBase {

  // Defaults, or Game over (creates new instance) ?
  SnakeStartBloc(){

      //print("Snake Start bloc Constructor called");
      sscreen_size;
      input_setting;
      g_theme_color;
      game_over;

      exp_pt = math.Point(28, 3);

      head_pt = math.Point(0, 0);
      food_pt = math.Point(0, 8);

      body = <math.Point<int>>[
        const math.Point<int>(0, 0)
      ];
      direction = const math.Point<int>(1, 0);

      // show_food_exp = false;
      show_food_exp = true;
    

      step_count = 0;
      show_food_exp_step = 0;
      foods_captured = 0;
      update_stream_has_listen = false;
      exp_stream_has_listen = false;
      show_food_exp = true;
  }

  // takes map
  update_bloc(Map uev){
    print("got update event map ~ " + uev.toString());
  }

  StreamController<Map> updateController = StreamController<Map>();
  StreamSink<Map> get update_sink => updateController.sink;
  Stream update_stream;
  bool update_stream_has_listen;

  Stream broadcast_update_stream(){
    Stream ic_bc_stream =  updateController.stream.asBroadcastStream();
    update_stream = ic_bc_stream;
    return ic_bc_stream;
  }

  StreamController<bool> expController = StreamController<bool>();
  StreamSink<bool> get exp_sink => expController.sink;
  Stream exp_stream;
  bool exp_stream_has_listen;


  broadcast_exp_stream(){

    //print("exp stream listener looks empty, add broadcast steram ...");
    Stream ic_bc_stream =  expController.stream.asBroadcastStream();
    exp_stream = ic_bc_stream;
    return ic_bc_stream;
  }

  Size sscreen_size;
  double ib_width = 0.0;
  int bloc_counter = 0;
  String input_setting = "Touch";
  Color g_theme_color = Colors.deepPurple;
  bool game_over = false;
  
  math.Point exp_pt = math.Point(0, 0);
  math.Point head_pt = math.Point(0, 0);
  math.Point food_pt = math.Point(0, 4);
  List<math.Point<int>> body = <math.Point<int>>[
    const math.Point<int>(0, 0)
  ];

  math.Point<int> direction;
  math.Point<int> newDirection ;


  // pull submit val out from snakestate
  String sub_val;

  int step_count;

  // show explosion when get food
  bool show_food_exp;

  // need to cut off explosion animation after a few steps
  int show_food_exp_step;

  int foods_captured;


  void reset_food() {
    int food_pt_x = random.nextInt(columns);
    int food_pt_y = random.nextInt(rows);
    print("x: " + food_pt_x.toString() + " y: " + food_pt_y.toString());
    food_pt = math.Point(food_pt_x, food_pt_y);

    // for testing
    // food_pt = math.Point(1, 8);
  }

  int score() {
    return (step_count + foods_captured * 100);
  }


  step(math.Point<int> newDirection, Function state_stepper) {
    //print("step head pos ::: " + head_pt.x.toString() + ", " + head_pt.y.toString());
    //print("step food pos ::: " + food_pt.x.toString() + ", " + food_pt.y.toString());
    //print("step exp pos ::: " + exp_pt.x.toString() + ", " + exp_pt.y.toString());
    //print("Food pos ::: " + food_pt.toString());
    print("step count ~ " + step_count.toString());
print("show food exp step ~ "+ show_food_exp_step.toString());
    /// wait ten steps after showing explosion to turn off
    if (step_count - show_food_exp_step > 3) {
      show_food_exp = false;
      exp_sink.add(false);
    }

     // print("Pre set body next direction :: " + direction.toString());
    math.Point<int> next = body.last + direction;
    next = math.Point<int>(next.x % columns, next.y % rows);
    head_pt = math.Point(next.x, next.y);
    body.add(next);
    if (body.length > snake_length) body.removeAt(0);
    direction = newDirection ?? direction;


// reset food if step_count is at interval
    if (step_count % food_reset_interval == 0 
      && step_count != 0
    ) {
      print("food set:: ");
      reset_food();
    }

    // init food only for TESTING
    if (step_count == 0){
      int food_pt_x = 3;
      int food_pt_y = 0;
    food_pt = math.Point(food_pt_x, food_pt_y);
    }


    if (head_pt.x == food_pt.x && head_pt.y == food_pt.y) {
      print("WINRAR got food");
      show_food_exp = true;

      foods_captured += 1;
      // set exp point for animation before calling sink

      exp_pt = head_pt;
      show_food_exp_step = step_count;

    //  print("GOT FOOD");
      snake_length += 1;

      exp_sink.add(true);
      reset_food();


    // speed snake 
      if (snake_game_timer != null) {
        print("Reset game timer not null");
        snake_game_timer.cancel();
      }

      print("reset for level with foods captured ~ " + foods_captured.toString());
      snake_game_timer = Timer.periodic(
          Duration(milliseconds: 555 - (30 * foods_captured)), (_) {
        state_stepper();
      });
    
    }
    step_count += 1;
  }

  void dispose(){
    snake_game_timer.cancel();
    updateController.close();
  }

}