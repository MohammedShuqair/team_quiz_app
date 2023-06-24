// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:team_quiz_app/widgets/quiz_header.dart';
import 'package:team_quiz_app/widgets/score_keeper_view.dart';

import '../constants.dart';
import '../modules/true_false/quiz_brain.dart';
import '../widgets/alert.dart';

import 'home.dart';

class TrueFalseQuiz extends StatefulWidget {
  static const routeName = 'level1';

  const TrueFalseQuiz({super.key});
  @override
  TrueFalseQuizState createState() => TrueFalseQuizState();
}

class TrueFalseQuizState extends State<TrueFalseQuiz> {
  QuizBrain quizBrain = QuizBrain();

  List<bool> scoreKeeper = [];

  int counter = 10;
  int correctResult = 0;
  late Timer timer;
  void addToScoreKeeper(bool isResultCorrect) {
    scoreKeeper.add(isResultCorrect);
    if (isResultCorrect) correctResult++;
  }

  void reset() {
    scoreKeeper.clear();
    quizBrain.reset();
    startTimer();
    counter = 10;
    correctResult = 0;
  }

  void popToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  void checkAnswer(
    BuildContext context,
    bool? userChoice,
  ) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    addToScoreKeeper(correctAnswer == userChoice);
    if (quizBrain.isFinished()) {
      setState(() {
        timer.cancel();

        showAlert(
            context: context,
            correctResult: correctResult,
            total: scoreKeeper.length,
            onTapRestart: () {
              Navigator.pop(context);
              reset();
            });
      });
    } else {
      quizBrain.nextQuestion();
      counter = 10;
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        counter--;
        if (counter == 0) {
          checkAnswer(context, null);
        }
      });
      print(counter);
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kBlueBg,
              kL2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 74, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              QuizHeader(
                counter: counter,
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      quizBrain.getQuestionText(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                    ),
                    child: const Text(
                      'True',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      //The user picked true.
                      checkAnswer(context, true);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: const ButtonStyle().copyWith(
                      backgroundColor: const MaterialStatePropertyAll(Colors.red),
                    ),
                    child: const Text(
                      'False',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      //The user picked false.
                      checkAnswer(context, false);
                    },
                  ),
                ),
              ),
              ScoreKeeperView(scoreKeeper: scoreKeeper),
              const SizedBox(
                height: 72,
              )
            ],
          ),
        ),
      ),
    );
  }
}
