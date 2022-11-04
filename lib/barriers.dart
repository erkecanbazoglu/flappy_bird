import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isBottomBarrier;

  const MyBarrier({
    Key? key,
    required this.barrierWidth,
    required this.barrierHeight,
    required this.barrierX,
    required this.isBottomBarrier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isBottomBarrier ? 1.05 : -1.05),
      child: Container(
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(
            width: 10,
            color: Colors.green.shade800,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
