import 'dart:math';

class EasyBotMove {
  static int easyBotMove(List<int> emptyFields) {
    final random = Random();
    return emptyFields[random.nextInt(emptyFields.length)];
  }
}