import 'package:flutter/material.dart';
import 'package:quizzlerapp/question_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Quizzler(),
    ),
  );
}

QuesBrain quizBrain = QuesBrain();

class Quizzler extends StatefulWidget {
  @override
  _QuizzlerState createState() => _QuizzlerState();
}

class _QuizzlerState extends State<Quizzler> {
  List<Icon> _scoreKeeper = [];

  //List of icons, displays the history of correct answers guessed

  void addbutton(var i, var c) {
    _scoreKeeper.add(
      Icon(
        i,
        color: c,
      ),
    );
  }

  //adds button to the list

  void checkanswer(bool userpickedanswer) {
    bool correctanswer = quizBrain.getAnswer();
    if (quizBrain.isFinished()) {
      print('The quiz is over');
      Alert(
        style: AlertStyle(
          overlayColor: Colors.black,
          backgroundColor: Colors.grey.shade900,
          titleStyle: TextStyle(color: Colors.white),
          descStyle: TextStyle(color: Colors.white),
        ),
        context: context,
        type: AlertType.error,
        title: "ALERT",
        desc: "The quiz is over",
        buttons: [
          DialogButton(
            color: Colors.blueGrey,
            child: Text(
              "RESET",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            onPressed: () {
              quizBrain.resetques();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Quizzler()),
              );
            },
            width: 120,
          )
        ],
      ).show();
      _scoreKeeper.clear();
    } else if (userpickedanswer == correctanswer) {
      quizBrain.nextques();
      addbutton(Icons.check, Colors.green);
      print('User guessed correct');
    } else {
      quizBrain.nextques();
      addbutton(Icons.close, Colors.red);
      print('User guessed wrong');
    }
  }

  //checks if the anser is correct and updates list

  Expanded newbutton(var c, var i, bool t) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FlatButton(
          onPressed: () {
            setState(() {
              checkanswer(t);
            });
          },
          color: c,
          child: Center(
            child: Text(
              '$t',
              style: TextStyle(fontSize: 25.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  //returns flat button, used for true and false buttons

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        quizBrain.getQuestion(),
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ),
                  ),
                ),
                newbutton(Colors.green, Icons.check, true),
                newbutton(Colors.red, Icons.close, false),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _scoreKeeper,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
