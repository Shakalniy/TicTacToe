import 'dart:math';

import 'package:tic_tac_toe/features/features.dart';

class MediumBotMove {
  static int mediumBotMove(List<int> emptyFields, List<int> playerFields, List<int> botFields) {
    final random = Random();
    List<int> corners = [1, 3, 7, 9];
    if(playerFields.isEmpty && emptyFields.contains(5)) {
      return 5;
    }
    else {
      if(playerFields.length == 1) {
        if(!playerFields.contains(5) && emptyFields.contains(5)) {
          return 5;
        }
        else {
          List<int> difference = corners.toSet().difference(playerFields.toSet()).toList();
          return difference[random.nextInt(difference.length)];
        }
      }
      else {
        List<int> winsFields = CheckWin.checkDanger(emptyFields, botFields);
        if(winsFields.isEmpty) {
          List<int> dangerFields = CheckWin.checkDanger(emptyFields, playerFields);
          if(dangerFields.isEmpty) {
            int numberOfNeighbour = CheckWin.findNeighbour(emptyFields, botFields);
            if(numberOfNeighbour == 0) {
              return emptyFields[0];
            }
            else {
              return numberOfNeighbour;
            }
          }
          else {
            return dangerFields[random.nextInt(dangerFields.length)];
          }
        }
        else {
          return winsFields[random.nextInt(winsFields.length)];
        }
      }
    }
  }
}