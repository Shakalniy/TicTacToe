import 'package:flutter/material.dart';
import '../exports.dart';

class TextInStats extends StatelessWidget {

  final String text;
  const TextInStats({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10),
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
          color: ColorConstant.menuMainTextColor,
          fontSize: 18,
          fontFamily: 'RobotoBlack',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}