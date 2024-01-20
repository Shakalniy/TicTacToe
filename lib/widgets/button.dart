import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/core/app_export.dart';

class Button extends StatelessWidget {

  final String text;
  final List<double> margin; //[top, bottom, left, right]
  final String route;
  final Object? arguments;

  const Button({
    super.key,
    required this.text,
    required this.margin,
    required this.route,
    this.arguments
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: margin[0], bottom: margin[1], left: margin[2], right: margin[3]),
      width: double.infinity,
      height: 50,
      child: MaterialButton(
        color: ColorConstant.menuButtonColor,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: "RobotoRegular",
            color: ColorConstant.menuButtonTextColor,
          ),
        ),
        onPressed: () {
          if (route == "/exit") {
            SystemNavigator.pop();
          }
          else {
            Navigator.pushNamed(context, route, arguments: arguments);
          }
        },
      ),
    );
  }

}