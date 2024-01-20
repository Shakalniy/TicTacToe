import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/exports.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 70, right: 20, left: 20, bottom: 50),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Крестики-Нолики",
                style: TextStyle(
                  color: ColorConstant.menuMainTextColor,
                  fontSize: 36,
                  fontFamily: 'RobotoBlack',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Button(text: "Игра с ботом", margin: [0, 50, 0, 0], route: "/one_player"),

                  Button(text: "Игра с человеком", margin: [0, 50, 0, 0], route: "/two_player_game"),

                  Button(text: "Настройки", margin: [0, 50, 0, 0], route: "/settings"),

                  Button(text: "Связь",  margin: [0, 50, 0, 0], route: "/link"),

                  Button(text: "Выход",  margin: [0, 50, 0, 0], route: "/exit"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}