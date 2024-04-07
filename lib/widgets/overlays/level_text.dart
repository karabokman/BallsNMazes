import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';

class LevelText extends StatelessWidget {
  static const String id = 'LevelText';
  final MazeGame gameRef;
  const LevelText({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Level ${gameRef.levelNumber}',
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
