import 'package:flutter/material.dart';
import 'main.dart';
import 'snake.dart';
import 'snakeStartBloc.dart';
import 'snekStateBase.dart';

class Snek_Options extends StatefulWidget {
  @override
  _Snek_OptionsState createState() => _Snek_OptionsState();
}

class _Snek_OptionsState extends State<Snek_Options> {
  Color g_theme_color;

  var dropdownValue;
  var dropdownValue2;

  bool _collisions_value = true;

  SnakeStartBloc ss_bloc_inst;
  Widget build(BuildContext context) {
    SnakeStartBloc ss_bloc_inst = SnakeStartBloc();
    ss_bloc_inst =
        snekStateProvider.of<SnakeStartBloc>(context);

    ss_bloc_inst.sscreen_size = MediaQuery.of(context).size;

    TextStyle ui_but_ts = TextStyle(fontSize: 30);

    _collisions_value = ss_bloc_inst.collisions_on;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          // Container(
          //   height: ss_bloc_inst.sscreen_size.height * .1,
          //   child: Center(
          //       child: Text(
          //     "Control Setting:",
          //     style: ui_but_ts,
          //   )),
          // ),
          Container(
            height: ss_bloc_inst.sscreen_size.width * .1,
          ),
          // Container(
          //     padding: EdgeInsets.symmetric(horizontal: ss_bloc_inst.sscreen_size.width * .13),
          //     child: DropdownButton<String>(
          //       value: dropdownValue,
          //       isExpanded: true,
          //       icon: Container(
          //           padding: EdgeInsets.only(right: ss_bloc_inst.sscreen_size.width * .08),
          //           child: Icon(
          //             Icons.arrow_downward,
          //             color: g_theme_color,
          //           )),
          //       iconSize: 24,
          //       elevation: 16,
          //       style: TextStyle(color: Colors.white),
          //       underline: Container(
          //         height: 2,
          //         color: g_theme_color,
          //       ),
          //       onChanged: (String newValue) {
          //         setState(() {
          //           dropdownValue = newValue;
          //         });
          //         setState(() {
          //           ss_bloc_inst.input_setting = newValue;
          //         });
          //         ss_bloc_inst.input_setting = newValue;
          //       },
          //       items: <String>['Tilt', 'Touch']
          //           .map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem<String>(
          //             value: value,
          //             child: Container(
          //               padding:
          //                   EdgeInsets.symmetric(horizontal: ss_bloc_inst.sscreen_size.width * .08),
          //               child: Row(children: [
          //                 Center(
          //                     child: Text(
          //                   value,
          //                   style: ui_but_ts,
          //                 ))
          //               ]),
          //             ));
          //       }).toList(),
          //     )),
          Container(
              padding: EdgeInsets.symmetric(horizontal: ss_bloc_inst.sscreen_size.width * .13),
              child: CheckboxListTile(
                  title: Text(
                    "Collisions",
                    style: ui_but_ts,
                  ),
                  selected: _collisions_value,
                  value: _collisions_value,
                  onChanged: (bool value) {
                    setState(() {
                      _collisions_value = value;
                      ss_bloc_inst.collisions_on = value;
                    });
                  })),
          Container(
            height: ss_bloc_inst.sscreen_size.width * .06,
          ),
          Container(
            height: ss_bloc_inst.sscreen_size.height * .1,
            child: Center(
                child: Text(
              "Color Setting:",
              style: ui_but_ts,
            )),
          ),
          Container(
            height: ss_bloc_inst.sscreen_size.width * .01,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: ss_bloc_inst.sscreen_size.width * .13),
              child: DropdownButton<String>(
                value: dropdownValue2,
                isExpanded: true,
                // icon: Container(
                //     padding: EdgeInsets.only(right: ss_bloc_inst.sscreen_size.width*.08),
                //     child:Icon(Icons.arrow_downward, color:Colors.green,)),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: ss_bloc_inst.g_theme_color,
                ),
                onChanged: (String value) {
                  Color dd_color;
                  if (value == "Purple") {
                    dd_color = Colors.deepPurple;
                  }
                  if (value == "Blue") {
                    dd_color = Colors.blueAccent;
                  }
                  if (value == "Green") {
                    dd_color = Colors.lightGreen;
                  }
                  if (value == "Red") {
                    dd_color = Colors.redAccent;
                  }
                  if (value == "Orange") {
                    dd_color = Colors.deepOrangeAccent;
                  }
                  setState(() {
                    ss_bloc_inst.g_theme_color = dd_color;
                    g_theme_color = dd_color;
                    dropdownValue2 = value;
                  });
                },
                items: <String>['Purple', 'Blue', 'Green', 'Red', 'Orange']
                    .map<DropdownMenuItem<String>>((String value) {
                  Color dd_color;
                  if (value == "Purple") {
                    dd_color = Colors.deepPurple;
                  }
                  if (value == "Blue") {
                    dd_color = Colors.blueAccent;
                  }
                  if (value == "Green") {
                    dd_color = Colors.lightGreen;
                  }
                  if (value == "Red") {
                    dd_color = Colors.redAccent;
                  }
                  if (value == "Orange") {
                    dd_color = Colors.deepOrangeAccent;
                  }
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        width: ss_bloc_inst.sscreen_size.width,
                        height: ss_bloc_inst.sscreen_size.height * .1,
                        color: dd_color,
                        child: Center(
                            child: Text(
                          value,
                          style: ui_but_ts,
                        )),
                      ));
                }).toList(),
              )),
        ],
      ),
    );
  }
}
