import 'package:flutter/material.dart';
import 'package:snek_si/main.dart';
import 'package:snek_si/snake.dart';


class Snek_Options extends StatefulWidget {
  @override
  _Snek_OptionsState createState() => _Snek_OptionsState();
}

class _Snek_OptionsState extends State<Snek_Options> {
  Color g_theme_color;

  var dropdownValue;
  var dropdownValue2;

  Widget build(BuildContext context) {
    GameState.game_over = true;
    return Scaffold(appBar: AppBar(),
    body: ListView(children: <Widget>[

      Container(height: gss.height * .1,child:
      Center(child:Text("Control Setting:",style: ui_but_ts,))
        ,),
      Container(height: gss.width*.01,),
      Container(

          padding: EdgeInsets.symmetric(horizontal: gss.width*.13),
          child: DropdownButton<String>(
            value: dropdownValue,
            isExpanded: true,
            icon: Container(
                padding: EdgeInsets.only(right: gss.width*.08),
                child:Icon(Icons.arrow_downward, color:g_theme_color,)),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: g_theme_color,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              GameState.input_setting = newValue;
            },
            items: <String>['Tilt', 'Touch']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: gss.width *.08),
                    child:Row(children:[Center(
                        child:Text(value,style:ui_but_ts ,))]),)
              );
            }).toList(),
          )
      ),


      Container(height: gss.width*.06,),
      Container(height: gss.height * .1,child:
      Center(child:Text("Color Setting:",style: ui_but_ts,))
        ,),
      Container(height: gss.width*.01,),
      Container(

          padding: EdgeInsets.symmetric(horizontal: gss.width*.13),
          child: DropdownButton<String>(
            value: dropdownValue2,
            isExpanded: true,
            // icon: Container(
            //     padding: EdgeInsets.only(right: gss.width*.08),
            //     child:Icon(Icons.arrow_downward, color:Colors.green,)),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: GameState.g_theme_color,
            ),
            onChanged: (String value) {
              Color dd_color;
              if (value == "Purple"){dd_color = Colors.deepPurple;}
              if (value == "Blue"){dd_color = Colors.blueAccent;}
              if (value == "Green"){dd_color = Colors.lightGreen;}
              if (value == "Red"){dd_color = Colors.redAccent;}
              if (value == "Orange"){dd_color = Colors.deepOrangeAccent;}
              setState(() {
                GameState.g_theme_color = dd_color;
                g_theme_color = dd_color;
                dropdownValue2 = value;
              });

            },
            items: <String>['Purple', 'Blue','Green','Red','Orange']
                .map<DropdownMenuItem<String>>((String value) {
              Color dd_color;
              if (value == "Purple"){dd_color = Colors.deepPurple;}
              if (value == "Blue"){dd_color = Colors.blueAccent;}
              if (value == "Green"){dd_color = Colors.lightGreen;}
              if (value == "Red"){dd_color = Colors.redAccent;}
              if (value == "Orange"){dd_color = Colors.deepOrangeAccent;}
              return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    width: gss.width,
                    height: gss.height * .1,
                    color: dd_color,child: Center(child:Text(value,style: ui_but_ts,)),
                  )
              );
            }).toList(),
          )
      ),
    ],),);
  }
}
