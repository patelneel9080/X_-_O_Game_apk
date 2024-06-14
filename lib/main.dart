import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, '');
  bool isPlayingWithComputer = false;
  bool isPlayerTurn = true;
  bool gameOver = false;
  String winner = '';
  Random random = Random();
  bool isHardMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(.9),
        title: Text('X & O',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isPlayingWithComputer ? 'Playing against Computer' : 'Playing with Friend',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.black.withOpacity(.9),),
                ),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (!gameOver && board[index].isEmpty) {
                          setState(() {
                            board[index] = isPlayerTurn ? 'X' : 'O';
                            isPlayerTurn = !isPlayerTurn;
                            checkGameOver();
                            if (isPlayingWithComputer && !gameOver && !isPlayerTurn) {
                              playComputerMove();
                            }
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(.9),),
                        ),
                        child: Center(
                          child: Text(
                            board[index],
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (gameOver)
              Text(
                winner.isNotEmpty ? (winner == 'O' ? 'Computer Wins!' : 'X Win!') : 'It\'s a draw!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(.9),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text('Restart Game',style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPlayingWithComputer = true;
                      resetGame();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(.9),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text('Play with Computer',style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPlayingWithComputer = false;
                      resetGame();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(.9),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text('Play with Friend',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkGameOver() {
    for (int i = 0; i < 9; i += 3) {
      if (board[i].isNotEmpty &&
          board[i] == board[i + 1] &&
          board[i + 1] == board[i + 2]) {
        setWinner(board[i]);
        return;
      }
    }

    for (int i = 0; i < 3; i++) {
      if (board[i].isNotEmpty &&
          board[i] == board[i + 3] &&
          board[i + 3] == board[i + 6]) {
        setWinner(board[i]);
        return;
      }
    }

    if (board[0].isNotEmpty &&
        board[0] == board[4] &&
        board[4] == board[8]) {
      setWinner(board[0]);
      return;
    }

    if (board[2].isNotEmpty &&
        board[2] == board[4] &&
        board[4] == board[6]) {
      setWinner(board[2]);
      return;
    }

    if (!board.contains('')) {
      setWinner('');
      return;
    }
  }

  void setWinner(String player) {
    setState(() {
      gameOver = true;
      winner = player;
    });
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayerTurn = true;
      gameOver = false;
      winner = '';
    });
  }

  void playComputerMove() {
    int moveIndex;
    do {
      moveIndex = random.nextInt(9);
    } while (board[moveIndex].isNotEmpty);

    setState(() {
      board[moveIndex] = 'O';
      isPlayerTurn = true;
      checkGameOver();
    });
  }
}
