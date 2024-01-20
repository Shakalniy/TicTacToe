import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../exports.dart';

class OnePlayerStart extends StatelessWidget {
  const OnePlayerStart({super.key});

  @override
  Widget build(BuildContext context) {
    var gameMode = (ModalRoute.of(context)?.settings.arguments ?? []) as String;
    return OnePlayerGame(gameMode: gameMode);
  }
}

class OnePlayerGame extends StatefulWidget {
  final String gameMode;
  const OnePlayerGame({
    super.key,
    required this.gameMode
  });

  @override
  State<StatefulWidget> createState() => _OnePlayerGame();
}

class _OnePlayerGame extends State<OnePlayerGame> {

  List<List<String>> stats = [[], [], []];
  Map<String, int> oneStats = {};
  String typeOfStats = "";
  List<int> allStats = [0, 0, 0, 0];

  bool playerIsFirst = true;

  IconData currentMove = Icons.clear_rounded; //cross

  List isFilled = [false, false, false, false, false, false, false, false, false];
  List<int> emptyFields = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  List<int> playerFields = [];
  List<int> botFields = [];

  int countOfRounds = 0;

  int countOfWinsCross = 0;
  int countOfWinsZeros = 0;
  int whoWin = 0;
  String message = "";

  Map<IconData, double> sizes = {
    Icons.clear_rounded: 98,
    Icons.radio_button_off: 78
  };

  void initStats(String type) async {
    typeOfStats = type;
    stats[0] = await _getStats('easyStats');
    stats[1] = await _getStats('mediumStats');
    stats[2] = await _getStats('hardStats');
    allStats = getFullStats(typeOfStats);
    setState(() {});
  }

  void initSettings() async {
    playerIsFirst = !await _getSetting(StringConstant.whoFirstInOneGame);
    playerIsFirst ? null : botMove();
  }

  Future<List<String>> _getStats(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<bool> _getSetting(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  List<int> getFullStats(String typeOfStats) {
    if(typeOfStats == "all") {
      List<int> result = [0, 0, 0];
      for (List<String> stat in stats) {
        for (var i = 0; i < stat.length; i++) {
          result[i] += int.parse(stat[i]);
        }
      }
      int sum = result.reduce((a, b) => a + b);
      result.add(sum);
      return result;
    }
    else {
      List<String> list = stats[oneStats[typeOfStats]!];
      List<int> result = [];
      for (var item in list) {
        result.add(int.parse(item));
      }
      int sum = result.reduce((a, b) => a + b);
      result.add(sum);
      return result;
    }
  }

  void setStats(int index) async {
    List<String> result = [];
    if (stats[oneStats[widget.gameMode]!].isEmpty) {
      List<String> list = ["0", "0", "0"];
      list[index] = "1";
      result = list;
    }
    else {
      int score = int.parse(stats[oneStats[widget.gameMode]!][index]);
      score += 1;
      result = stats[oneStats[widget.gameMode]!];
      result[index] = score.toString();
    }

    _setStats(result, "${widget.gameMode}Stats");
  }

  void _resetStats (String typeOfStats) async {
    if (typeOfStats == "all") {
      _setStats(["0", "0", "0"], "easyStats");
      _setStats(["0", "0", "0"], "mediumStats");
      _setStats(["0", "0", "0"], "hardStats");
    }
    else {
      _setStats(["0", "0", "0"], "${typeOfStats}Stats");
    }
    initStats(typeOfStats);
  }

  Future _setStats(List<String> stats, String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, stats);
  }

  void move(int numberOfField, bool isPlayer) {
    isFilled[numberOfField - 1] = currentMove;
    emptyFields.removeWhere((element) => element == numberOfField);

    if (isPlayer) {
      playerFields.add(numberOfField);
    }
    else {
      botFields.add(numberOfField);
    }

    if (CheckWin.checkWin(playerFields)) {
      countOfWinsCross += 1;
      whoWin = 1;
      message = "Победил Игрок!";
      setStats(0);
    }
    else if (CheckWin.checkWin(botFields)) {
      countOfWinsZeros += 1;
      whoWin = 2;
      message = "Победил Бот!";
      setStats(1);
    }
    countOfRounds += 1;
    if(countOfRounds == 9 && whoWin == 0) {
      message = "Ничья!";
      whoWin = -1;
      setStats(2);
    }
    currentMove = playerIsFirst ? Icons.clear_rounded : Icons.radio_button_off;
    setState(() {});
  }

  void playerMove(int numberOfField) {
    currentMove = playerIsFirst ? Icons.clear_rounded : Icons.radio_button_off;
    move(numberOfField, true);
  }

  void botMove() {
    final int numberOfField;
    if(widget.gameMode == "easy") {
      numberOfField = EasyBotMove.easyBotMove(emptyFields);
    }
    else if (widget.gameMode == "medium") {
      numberOfField = MediumBotMove.mediumBotMove(emptyFields, playerFields, botFields);
    }
    else if (widget.gameMode == "hard") {
      var board = HardBotMove.formBoard(playerFields, botFields);
      numberOfField = HardBotMove.play(board, -1) + 1;
    }
    else {
      numberOfField = 0;
    }
    currentMove = playerIsFirst ? Icons.radio_button_off : Icons.clear_rounded;
    move(numberOfField, false);
  }

  void restart() {
    whoWin = 0;
    playerIsFirst = !playerIsFirst;
    currentMove = playerIsFirst ? Icons.clear_rounded : Icons.radio_button_off;
    playerFields = [];
    botFields = [];
    isFilled = [false, false, false, false, false, false, false, false, false];
    message = "";
    countOfRounds = 0;
    emptyFields = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    setState(() {});

    playerIsFirst ? null : botMove();
  }

  @override
  void initState() {
    oneStats = {
      "easy": 0,
      "medium": 1,
      "hard": 2,
    };
    initStats(widget.gameMode);
    initSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 20),
                child: IconButton(
                  icon: const Icon(Icons.insert_chart_outlined),
                  color: Colors.black,
                  onPressed: () {
                    initStats(widget.gameMode);
                    showGeneralDialog(context);
                  },
                ),
              ),
            ],
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
                      Icons.person,
                      color: Colors.blue,
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
                      Icons.android_outlined,
                      color: Colors.green,
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
                            playerMove(1);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[0] == false ? Icons.add : isFilled[0],
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
                            playerMove(2);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[1] == false ? Icons.add : isFilled[1],
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
                            playerMove(3);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[2] == false ? Icons.add : isFilled[2],
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
                            playerMove(4);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[3] == false ? Icons.add : isFilled[3],
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
                            playerMove(5);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[4] == false ? Icons.add : isFilled[4],
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
                            playerMove(6);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[5] == false ? Icons.add : isFilled[5],
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
                            playerMove(7);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[6] == false ? Icons.add : isFilled[6],
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
                            playerMove(8);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[7] == false ? Icons.add : isFilled[7],
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
                            playerMove(9);
                            whoWin == 0 ? botMove() : null;
                          },
                          child: Icon(
                            isFilled[8] == false ? Icons.add : isFilled[8],
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
                    color: ColorConstant.menuMainTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: "RobotoBlack",
                  ),
                ),
                onPressed: () async {
                  restart();
                }
            ),
          )
        ],
      ),
    );
  }

  showGeneralDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: ColorConstant.scaffoldBackgroundColor,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.only(left: 10, right: 10),
              content: AspectRatio(
                aspectRatio: 1,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Статистика",
                        style: TextStyle(
                          color: ColorConstant.menuMainTextColor,
                          fontSize: 24,
                          fontFamily: 'RobotoBlack',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: ColorConstant.menuMainTextColor,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              height: double.infinity,
                              color: typeOfStats == "all" ? ColorConstant.chosenButtonBackgroundColor : ColorConstant.scaffoldBackgroundColor,
                              child: Text(
                                "Вся статистика",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorConstant.menuMainTextColor,
                                  fontSize: 12,
                                  fontFamily: 'RobotoBlack',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                initStats("all");
                                setState(() {});
                              },
                            )
                          ),
                          Expanded(
                              child: MaterialButton(
                                padding: EdgeInsets.zero,
                                height: double.infinity,
                                color: typeOfStats == "easy" ? ColorConstant.chosenButtonBackgroundColor : ColorConstant.scaffoldBackgroundColor,
                                child: Text(
                                  "Лёгкий",
                                  style: TextStyle(
                                    color: ColorConstant.menuMainTextColor,
                                    fontSize: 12,
                                    fontFamily: 'RobotoBlack',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  initStats("easy");
                                  setState(() {});
                                },
                              )
                          ),
                          Expanded(
                              child: MaterialButton(
                                padding: EdgeInsets.zero,
                                height: double.infinity,
                                color: typeOfStats == "medium" ? ColorConstant.chosenButtonBackgroundColor : ColorConstant.scaffoldBackgroundColor,
                                child: Text(
                                  "Средний",
                                  style: TextStyle(
                                    color: ColorConstant.menuMainTextColor,
                                    fontSize: 12,
                                    fontFamily: 'RobotoBlack',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  initStats("medium");
                                  setState(() {});
                                },
                              )
                          ),
                          Expanded(
                              child: MaterialButton(
                                height: double.infinity,
                                padding: EdgeInsets.zero,
                                color: typeOfStats == "hard" ? ColorConstant.chosenButtonBackgroundColor : ColorConstant.scaffoldBackgroundColor,
                                child: Text(
                                  "Сложный",
                                  style: TextStyle(
                                    color: ColorConstant.menuMainTextColor,
                                    fontSize: 12,
                                    fontFamily: 'RobotoBlack',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  initStats("hard");
                                  setState(() {});
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(height: 30,),
                    TextInStats(text: "Количество побед: ${allStats[0]}"),
                    TextInStats(text: "Количество поражений: ${allStats[1]}"),
                    TextInStats(text: "Количество ничьих: ${allStats[2]}"),
                    TextInStats(text: "Общее количество игр: ${allStats[3]}"),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: MaterialButton(
                        color: ColorConstant.chosenButtonBackgroundColor,
                        child: Text(
                          "Сбросить выбранную статистику",
                          style: TextStyle(
                            color: ColorConstant.menuMainTextColor,
                            fontSize: 14,
                            fontFamily: 'RobotoBlack',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async{
                          var ans = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                'Подтверждение сброса',
                                style: TextStyle(
                                    color: ColorConstant.menuMainTextColor
                                ),
                              ),
                              content: Text(
                                'Вы точно хотите сбросить статистику ?',
                                style: TextStyle(
                                    color: ColorConstant.menuMainTextColor
                                ),
                              ),
                              backgroundColor: ColorConstant.scaffoldBackgroundColor,
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Нет'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('Да'),
                                ),
                              ],
                            ),
                          );
                          if (ans == "OK") {
                            _resetStats(typeOfStats);
                            setState(() {});
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}