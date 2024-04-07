import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/widgets/overlays/pause_menu.dart';

class PauseButton extends StatelessWidget {
  static const String id = 'PauseButton';
  final MazeGame gameRef;
  const PauseButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TextButton(
          onPressed: () {
            gameRef.stopTimeTaken();
            gameRef.pauseEngine();
            gameRef.overlays.add(PauseMenu.id);
            gameRef.overlays.remove(PauseButton.id);
          },
          child: const Icon(
            Icons.pause,
            color: Colors.white,
          )),
    );
  }
}
