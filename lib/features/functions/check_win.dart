class CheckWin {
  static bool checkWin (List<int> filledFields) {
    if (filledFields.length < 3) {
      return false;
    }
    bool result = minicheck([1, 2, 3], filledFields) || minicheck([4, 5, 6], filledFields) || minicheck([7, 8, 9], filledFields)
        || minicheck([1, 4, 7], filledFields) || minicheck([2, 5, 8], filledFields) || minicheck([3, 6, 9], filledFields)
        || minicheck([1, 5, 9], filledFields) || minicheck([3, 5, 7], filledFields);

    return result;
  }

  static bool minicheck(List<int> winList, List<int> list) {
    return list.toSet().intersection(winList.toSet()).length == winList.length;
  }

  static List<int> checkDanger(List<int> emptyFields, List<int> moves) {
    List<int> result = [];
    List<List<int>> winsLines = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]];
    for (var line in winsLines) {
      List<int> iconsInLine = [];
      for (var field in moves) {
        if (line.contains(field)) {
          iconsInLine.add(field);
        }
      }
      if (iconsInLine.length == 2) {
        List<int> difference = line.toSet().difference(iconsInLine.toSet()).toList();
        if(emptyFields.contains(difference[0])) {
          result.add(difference[0]);
        }
      }
    }
    return result;
  }

  static int findNeighbour(List<int> emptyFields, List<int> moves) {
    for (var field in moves) {
      if (field == 5) {
        return emptyFields[0];
      }
      else {
        for (var i = 1; i < 5; i++) {
          if(emptyFields.contains(field + i) && field + i <= 9) {
            return field + i;
          }
          else if (emptyFields.contains(field - i) && field - i >= 1){
            return field - i;
          }
        }
      }
    }
    return 0;
  }
}