import 'package:flutter/material.dart';
import 'package:tic_tac_toe/exports.dart';

class LinkPage extends StatelessWidget {
  const LinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 20),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              color: ColorConstant.menuMainTextColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Автор: Шакальный",
                    style: TextStyle(
                        color: ColorConstant.menuMainTextColor,
                        fontSize: 20
                    ),
                  ),
                  SelectableText(
                    "Почта: support@gmail.com",
                    style: TextStyle(
                      color: ColorConstant.menuMainTextColor,
                      fontSize: 20,
                      decorationColor: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

}