import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'exports.dart';
import 'router/router.dart';

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {

  @override
  void initState() {
    super.initState();
    setHighRefresh();
  }

  Future<void> setHighRefresh() async {
    await FlutterDisplayMode.setHighRefreshRate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Крестики-Нолики',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
      theme: ThemeData(
        scaffoldBackgroundColor: ColorConstant.scaffoldBackgroundColor,
      ),
    );
  }
}