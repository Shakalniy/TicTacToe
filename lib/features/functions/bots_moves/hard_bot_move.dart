import 'utils/game_util.dart';

class HardBotMove {
  static const WIN_SCORE = 100;
  static const LOSE_SCORE = -100;
  static const DRAW_SCORE = 0;

  static List<int> formBoard(List<int> playerFields, List<int> botFields, ) {
    List<int> board =  List.generate(9, (index) => 0);
    for (var i = 0; i < 9; i++) {
      if (playerFields.contains(i + 1)) {
        board[i] = 1;
      }
      else if (botFields.contains(i + 1)) {
        board[i] = -1;
      }
    }

    return board;
  }

  static int play(List<int> board, int currentPlayer) { // 1 or -1
    return _getAIMove(board, currentPlayer).move;
  }

  static Move _getAIMove(List<int> board, int currentPlayer) {
    List<int> _newBoard;
    Move _bestMove = Move(score: -10000, move: -1);

    for (int currentMove = 0; currentMove < board.length; currentMove++) {
      if (!GameUtil.isValidMove(board, currentMove)) continue;
      _newBoard = List.from(board);
      _newBoard[currentMove] = currentPlayer;
      int _newScore = -_getBestScore(
        _newBoard,
        GameUtil.togglePlayer(currentPlayer),
      );
      if (_newScore > _bestMove.score) {
        _bestMove.score = _newScore;
        _bestMove.move = currentMove;
      }
    }

    return _bestMove;
  }

  static int _getBestScore(List<int> board, int currentPlayer) {
    final _winner = GameUtil.checkIfWinnerFound(board);
    if (_winner == currentPlayer) {
      return WIN_SCORE;
    } else if (_winner == GameUtil.togglePlayer(currentPlayer)) {
      return LOSE_SCORE;
    } else if (_winner == GameUtil.DRAW) {
      return DRAW_SCORE;
    }
    return _getAIMove(board, currentPlayer).score;
  }
}

class Move {
  int score;
  int move;

  Move({
    required this.score,
    required this.move,
  });
}