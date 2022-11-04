import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final double birdY;
  const MyBird({Key? key, required this.birdY}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, birdY),
      color: Colors.blue,
      child: Container(
        height: 60,
        width: 60,
        child: Image.asset('images/flappy-bird.png'),
      ),
    );
  }
}
