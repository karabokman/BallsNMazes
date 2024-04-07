import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/screens/main_menu_screen.dart';
import 'package:balls_n_mazes/widgets/overlays/did_you_know_screen.dart';
import 'package:balls_n_mazes/widgets/overlays/level_text.dart';
import 'package:balls_n_mazes/widgets/overlays/pause_button.dart';
import 'package:balls_n_mazes/widgets/overlays/power_up_text.dart';
import 'package:balls_n_mazes/widgets/overlays/start_level_menu.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final MazeGame gameRef;
  const PauseMenu({super.key, required this.gameRef});

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
              child: Text('Paused',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Gold', style: TextStyle(fontSize: 14.0)),
                      SizedBox(
                        width: width / 3,
                      ),
                      Text('${gameRef.getGoldTime()} ',
                          style: const TextStyle(fontSize: 14.0))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Silver', style: TextStyle(fontSize: 14.0)),
                      SizedBox(
                        width: width / 3,
                      ),
                      Text('${gameRef.getSilverTime()} ',
                          style: const TextStyle(fontSize: 14.0))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Bronze', style: TextStyle(fontSize: 14.0)),
                      SizedBox(
                        width: width / 3,
                      ),
                      const Text('04:00', style: TextStyle(fontSize: 14.0))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    gameRef.resumeEngine();
                    gameRef.overlays.remove(PauseMenu.id);
                    gameRef.overlays.add(PauseButton.id);
                    gameRef.continueTimer();
                  },
                  child: const Text('Resume')),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () async {
                    gameRef.overlays.remove(PauseMenu.id);
                    gameRef.overlays.remove(LevelText.id);
                    gameRef.overlays.remove(PowerUpText.id);
                    gameRef.setCurrentFact();
                    gameRef.overlays.add(DidYouKnowScreen.id);
                    gameRef.replayLevel();
                    await Future.delayed(const Duration(seconds: 3), () {
                      gameRef.overlays.remove(DidYouKnowScreen.id);
                      gameRef.overlays.add(StartLevelMenu.id);
                    });
                  },
                  child: const Text('Replay')),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    gameRef.overlays.remove(PauseMenu.id);
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
