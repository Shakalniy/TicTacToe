import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../exports.dart';

class TwoPlayersGame extends StatefulWidget {
  const TwoPlayersGame({super.key});

  @override
  State<StatefulWidget> createState() => _TwoPlayersGameState();

}

class _TwoPlayersGameState extends State<TwoPlayersGame> {

  bool crossIsFirst = true;
  List isFilled = [false, false, false, false, false, false, false, false, false];
  List<int> crossFields = [];
  List<int> zerosFields = [];
  int countOfRounds = 0;
  IconData currentMove = Icons.clear_rounded; //cross
  int countOfWinsCross = 0;
  int countOfWinsZeros = 0;
  int whoWin = 0;
  String message = "";

  Map<IconData, double> sizes = {
    Icons.clear_rounded: 98,
    Icons.radio_button_off: 78
  };

  void initWhoFirst() async {
    crossIsFirst = !await _getSetting(StringConstant.whoFirstInTwoGame);
    setState(() {});
  }

  Future<bool> _getSetting(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  void move (int numberOfField){
    isFilled[numberOfField - 1] = currentMove;
    if (currentMove == Icons.clear_rounded) {
      crossFields.add(numberOfField);
    }
    else {
      zerosFields.add(numberOfField);
    }

    if (CheckWin.checkWin(crossFields)) {
      countOfWinsCross += 1;
      whoWin = 1;
      message = "Победил Игрок 1!";
      print("cross wins");
    }
    else if (CheckWin.checkWin(zerosFields)) {
      countOfWinsZeros += 1;
      whoWin = 2;
      message = "Победил Игрок 2!";
      print("zeros wins");
    }
    else {
      currentMove = currentMove == Icons.clear_rounded ? Icons.radio_button_off : Icons.clear_rounded;
    }
    countOfRounds += 1;
    if(countOfRounds == 9 && whoWin == 0) {
      message = "Ничья!";
      whoWin = -1;
    }
    setState(() {});
  }

  void restart() {
    whoWin = 0;
    crossIsFirst = !crossIsFirst;
    currentMove = crossIsFirst ? Icons.clear_rounded : Icons.radio_button_off;
    crossFields = [];
    zerosFields = [];
    isFilled = [false, false, false, false, false, false, false, false, false];
    message = "";
    countOfRounds = 0;
    setState(() {});
  }

  @override
  void initState() {
    initWhoFirst();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 20),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Icon(
              currentMove,
              color: Colors.black,
              size: 70,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              message,
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontFamily: "RobotoBlack",
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.clear_rounded,
                      color: Colors.black,
                      size: 60.0,
                    ),
                    Text(
                      countOfWinsCross.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        fontFamily: "RobotoBlack",
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.radio_button_off,
                      color: Colors.black,
                      size: 60.0,
                    ),
                    Text(
                      countOfWinsZeros.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        fontFamily: "RobotoBlack",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.black,
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                  height: 98,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[0] != false || whoWin != 0 ? null : () {
                            move(1);
                          },
                          child: Icon(
                            isFilled[0] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[0] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[0]],
                          ),
                        ),
                      ),
                      Container(
                        width: 5,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[1] != false || whoWin != 0 ? null : () {
                            move(2);
                          },
                          child: Icon(
                            isFilled[1] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[1] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[1]],
                          ),
                        ),
                      ),
                      Container(
                        width: 5,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[2] != false || whoWin != 0 ? null : () {
                            move(3);
                          },
                          child: Icon(
                            isFilled[2] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[2] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[2]],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                  height: 98,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[3] != false || whoWin != 0 ? null : () {
                            move(4);
                          },
                          child: Icon(
                            isFilled[3] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[3] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[3]],
                          ),
                        ),
                      ),
                      Container(
                        width: 5,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[4] != false || whoWin != 0 ? null : () {
                            move(5);
                          },
                          child: Icon(
                            isFilled[4] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[4] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[4]],
                          ),
                        ),
                      ),
                      Container(
                        width: 5,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[5] != false || whoWin != 0 ? null : () {
                            move(6);
                          },
                          child: Icon(
                            isFilled[5] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[5] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[5]],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                  height: 98,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[6] != false || whoWin != 0 ? null : () {
                            move(7);
                          },
                          child: Icon(
                            isFilled[6] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[6] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[6]],
                          ),
                        ),
                      ),
                      Container(
                        width: 5,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[7] != false || whoWin != 0 ? null : () {
                            move(8);
                          },
                          child: Icon(
                            isFilled[7] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[7] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[7]],
                          ),
                        ),
                      ),
                      Container(
                        width: 5,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.only(right: 0),
                          height: double.infinity,
                          onPressed: isFilled[8] != false || whoWin != 0 ? null : () {
                            move(9);
                          },
                          child: Icon(
                            isFilled[8] == Icons.clear_rounded ? Icons.clear_rounded : Icons.radio_button_off,
                            color: isFilled[8] != false ? Colors.black: Colors.white,
                            size: sizes[isFilled[8]],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          whoWin == 0 ? Container()
            :Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 30),
            child: MaterialButton(
              color: ColorConstant.scaffoldBackgroundColor,
              child: Text(
                "Продолжить ?",
                style: TextStyle(
                  color: Colors.white,//ColorConstant.menuMainTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: "RobotoBlack",
                ),
              ),
              onPressed: () {
                restart();
              }
            ),
          )
        ],
      ),
    );
  }
}