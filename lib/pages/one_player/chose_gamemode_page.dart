import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../exports.dart';

class ChoseGameModePage extends StatefulWidget {
  const ChoseGameModePage({super.key,});

  @override
  State<ChoseGameModePage> createState() => _ChoseGameModePageState();
}

class _ChoseGameModePageState extends State<ChoseGameModePage> {

  String typeOfStats = "all";
  List<int> allStats = [0, 0, 0, 0];
  Map<String, int> oneStats = {};
  List<List<String>> stats = [[], [], []];

  void initStats(String type) async {
    typeOfStats = type;
    stats[0] = await _getStats('easyStats');
    stats[1] = await _getStats('mediumStats');
    stats[2] = await _getStats('hardStats');
    allStats = getStats(typeOfStats);
    oneStats = {
      "easy": 0,
      "medium": 1,
      "hard": 2,
    };
    setState(() {});
  }

  Future _setStats(List<String> stats, String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, stats);
  }

  Future<List<String>> _getStats(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  List<int> getStats(String typeOfStats) {
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
      List<String> list = stats[oneStats[typeOfStats]!] ;
      List<int> result = [];
      for (var item in list) {
        result.add(int.parse(item));
      }
      int sum = result.reduce((a, b) => a + b);
      result.add(sum);
      return result;
    }
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
    initStats("all");
  }

  @override
  void initState() {
    initStats("all");
    super.initState();
  }

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
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              "Выбор сложности игры",
              style: TextStyle(
                color: ColorConstant.menuMainTextColor,
                fontSize: 24,
                fontFamily: 'RobotoBlack',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Button(text: "Лёгкий", margin: [0, 50, 0, 0], route: "/one_player_game", arguments: "easy"),
                const Button(text: "Средний", margin: [0, 50, 0, 0], route: "/one_player_game", arguments: "medium"),
                const Button(text: "Сложный", margin: [0, 50, 0, 0], route: "/one_player_game", arguments: "hard"),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                      color: ColorConstant.menuButtonColor,
                      child: Text(
                        "Статистика",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          fontFamily: "RobotoRegular",
                          color: ColorConstant.menuButtonTextColor,
                        ),
                      ),
                    onPressed: () {
                      initStats("all");
                      showGeneralDialog(context);
                    }
                  ),
                ),
              ],
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
                              "Сбросить статистику",
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