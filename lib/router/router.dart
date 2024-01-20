import '../exports.dart';

final routes = {
  '/': (context) => const MenuPage(),
  '/one_player': (context) => const ChoseGameModePage(),
  '/two_player_game': (context) => const TwoPlayersGame(),
  '/settings': (context) => const Settings(),
  '/link': (context) => const LinkPage(),
  '/one_player_game': (context) => const OnePlayerStart(),
};