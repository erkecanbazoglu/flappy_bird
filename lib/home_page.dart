import 'dart:async';

import 'package:flappy_bird/barriers.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdY;
  double gravity = -3.8;
  double velocity = 2.5;
  bool gameHasStarted = false;

  //Highscore
  int score = 0;
  int highscore = 10;
  bool highscorePassed = false;

  //Bird
  double birdWidth = 0.1;
  double birdHeight = 0.1;

//Barriers8
  List<double> barrierX = [2, 2 + 1.5];
  double barrierWidth = 0.5; //Out of 2
  List<List<double>> barrierHeight = [
    [0.8, 0.6],
    [0.6, 0.8]
  ]; //Out of 2 [topHeight, bottomHeight]

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdY;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialHeight - height;

        if (barrierX[0] < -1.7) {
          barrierX[0] += 3.2;
        } else {
          barrierX[0] -= 0.05;
        }

        if (barrierX[1] < -1.7) {
          barrierX[1] += 3.2;
        } else {
          barrierX[1] -= 0.05;
        }
      });

      if (birdIsDead()) {
        timer.cancel();
        if (score > highscore) {
          highscore = score;
          highscorePassed = true;
        }
        _showMyDialog();
      }
    });
  }

  bool birdIsDead() {
    //Checks if the bird is hitting the top or the bottom of the screen
    if (birdY > 1.05 || birdY < -1.05) {
      return true;
    }
    //Checks if the bird is hitting one of the obstacles
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    Navigator.of(context).pop();
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdY;
      barrierX = [2, 2 + 1.5];
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "G A M E    O V E R",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.brown,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                highscorePassed
                    ? const Text(
                        'Well done, you beat your highscore!',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Is this your best? \n\nMaybe you can do better next time.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'PLAY AGAIN',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  MyBird(
                    birdY: birdY,
                  ),
                  Container(
                    alignment: const Alignment(0, -0.3),
                    child: gameHasStarted
                        ? const Text("")
                        : const Text(
                            "T A P    T O    P L A Y",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),

                  //Top Barrier 0
                  MyBarrier(
                    barrierX: barrierX[0],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[0][0],
                    isBottomBarrier: false,
                  ),

                  //Bottom Barrier 0
                  MyBarrier(
                    barrierX: barrierX[0],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[0][1],
                    isBottomBarrier: true,
                  ),

                  //Top Barrier 1
                  MyBarrier(
                    barrierX: barrierX[1],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[1][0],
                    isBottomBarrier: false,
                  ),

                  //Bottom Barrier 1
                  MyBarrier(
                    barrierX: barrierX[1],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[1][1],
                    isBottomBarrier: true,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    color: Colors.brown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "SCORE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              score.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "BEST",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              highscore.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
