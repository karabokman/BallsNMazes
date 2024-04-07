import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/screens/main_menu_screen.dart';
import 'package:balls_n_mazes/widgets/overlays/did_you_know_screen.dart';
import 'package:balls_n_mazes/widgets/overlays/level_text.dart';
import 'package:balls_n_mazes/widgets/overlays/power_up_text.dart';
import 'package:balls_n_mazes/widgets/overlays/start_level_menu.dart';

class GameOverMenu extends StatelessWidget {
  static const String id = 'GameOverMenu';
  final MazeGame gameRef;
  const GameOverMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Text('Game Over',
                    style: Theme.of(context).textTheme.headlineLarge)),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text('Time out, try again.',
                  style: TextStyle(fontSize: 20.0)),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () async {
                    gameRef.overlays.remove(GameOverMenu.id);
                    gameRef.overlays.remove(LevelText.id);
                    gameRef.overlays.remove(PowerUpText.id);
                    gameRef.setCurrentFact();
                    gameRef.overlays.add(DidYouKnowScreen.id);
                    gameRef.replayLevel();
                    await Future.delayed(const Duration(seconds: 3), () {
                      gameRef.overlays.remove(DidYouKnowScreen.id);
                    });
                    gameRef.overlays.add(StartLevelMenu.id);
                  },
                  child: const Text('Replay')),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    gameRef.overlays.remove(GameOverMenu.id);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MainMenuScreen()));
                  },
                  child: const Text('Exit')),
            ),
          ],
        ),
      ),
    );
  }
}
