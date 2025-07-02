import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.screen.dart';

class TicTacToeScreen extends StatelessWidget {
  final String login;

  const TicTacToeScreen({required this.login});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F7FF),
      appBar: AppBar(
        title: Text('Tic Tac Toe - Joueur: $login'),
        backgroundColor: Colors.blue[600],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('login');
              await prefs.remove('password');

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),
      body: Center(
        child: TicTacToeGame(),
      ),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> _board = List.filled(9, '');
  bool _xTurn = true;

  void _handleTap(int index) {
    setState(() {
      if (_board[index] == '') {
        _board[index] = _xTurn ? 'X' : 'O';
        _xTurn = !_xTurn;
        _checkWinner();
      }
    });
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _xTurn = true;
    });
  }

  void _checkWinner() {
    final lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      final a = line[0];
      final b = line[1];
      final c = line[2];

      if (_board[a] != '' && _board[a] == _board[b] && _board[a] == _board[c]) {
        _showResultDialog('Le joueur "${_board[a]}" a gagné !');
        return;
      }
    }

    if (!_board.contains('')) {
      _showResultDialog("Égalité !");
    }
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Résultat',
          style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text(
              'Rejouer',
              style: TextStyle(color: Colors.blue[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(int index) {
    Color? bgColor;
    Color textColor;

    if (_board[index] == 'X') {
      bgColor = Colors.blue[100];
      textColor = Colors.blue[800]!;
    } else if (_board[index] == 'O') {
      bgColor = Colors.red[100];
      textColor = Colors.red[800]!;
    } else {
      bgColor = Colors.grey[200];
      textColor = Colors.grey[600]!;
    }

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.blueGrey.shade100,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            _board[index],
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: textColor,
              shadows: [
                Shadow(
                  blurRadius: 3,
                  color: Colors.black12,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                blurRadius: 30,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => _buildCell(index),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: 160,
          height: 48,
          child: ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
              shadowColor: Colors.blueAccent,
            ),
            child: Text(
              'Réinitialiser',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
