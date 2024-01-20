import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../exports.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool oneGameBotIsFirst = false;
  bool twoGameZerosIsFirst = false;

  Future<bool> _getSetting(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future _setSetting(bool setting, String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, setting);
  }

  void initSettings() async {
    oneGameBotIsFirst = await _getSetting(StringConstant.whoFirstInOneGame);
    twoGameZerosIsFirst = await _getSetting(StringConstant.whoFirstInTwoGame);
    setState(() {});
  }

  @override
  void initState() {
    initSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
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
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  "Настройки",
                  style: TextStyle(
                    color: ColorConstant.menuMainTextColor,
                    fontSize: 36,
                    fontFamily: 'RobotoBlack',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    const SizedBox(height: 40,),
                    Text(
                      "Настройки игры с ботом",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstant.menuMainTextColor,
                        fontSize: 24,
                        fontFamily: 'RobotoBlack',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Divider(height: 1, color: ColorConstant.menuMainTextColor, thickness: 1, indent: 20, endIndent: 20,),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Первым ходит бот",
                              style: TextStyle(
                                color: ColorConstant.menuMainTextColor,
                                fontSize: 18,
                                fontFamily: 'RobotoBlack',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Checkbox(
                              value: oneGameBotIsFirst,
                              onChanged: (bool? value) {
                                setState(() {
                                  oneGameBotIsFirst = value!;
                                  _setSetting(oneGameBotIsFirst, StringConstant.whoFirstInOneGame);
                                });
                                // initSettings();
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Text(
                        "Настройки игры с человеком",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorConstant.menuMainTextColor,
                          fontSize: 24,
                          fontFamily: 'RobotoBlack',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Divider(height: 1, color: ColorConstant.menuMainTextColor, thickness: 1, indent: 15, endIndent: 15,),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Первым ходит ноль",
                              style: TextStyle(
                                color: ColorConstant.menuMainTextColor,
                                fontSize: 18,
                                fontFamily: 'RobotoBlack',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Checkbox(
                                value: twoGameZerosIsFirst,
                                onChanged: (bool? value) {
                                  setState(() {
                                    twoGameZerosIsFirst = value!;
                                    _setSetting(twoGameZerosIsFirst, StringConstant.whoFirstInTwoGame);
                                  });
                                  // initSettings();
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

