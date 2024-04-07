import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';

class PowerUpText extends StatelessWidget {
  static const String id = 'PowerUpText';
  final MazeGame gameRef;
  const PowerUpText({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 45.0, right: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.flash_on,
              color: Colors.white,
              size: 28,
            ),
            Text(
              '${gameRef.powerUps}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
