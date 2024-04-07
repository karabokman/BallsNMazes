import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/screens/main_menu_screen.dart';
import 'package:balls_n_mazes/widgets/overlays/did_you_know_screen.dart';
import 'package:balls_n_mazes/widgets/overlays/level_text.dart';
import 'package:balls_n_mazes/widgets/overlays/power_up_text.dart';
import 'package:balls_n_mazes/widgets/overlays/start_level_menu.dart';

class WinMenu extends StatelessWidget {
  static const String id = 'WinMenu';
  final MazeGame gameRef;
  const WinMenu({super.key, required this.gameRef});

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
              child: Text('Success',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Level ${gameRef.levelNumber} complete',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text('Time: ${gameRef.getTimetaken()}',
                      style: const TextStyle(fontSize: 20.0)),
                  Text(
                    gameRef.getBadge(),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  gameRef.isFirstTime
                      ? const Text(
                          'New Best Time + 5',
                          style: TextStyle(fontSize: 14.0),
                        )
                      : Container(),
                  gameRef.isFirstTime
                      ? const Text(
                          'First time bonus +5',
                          style: TextStyle(fontSize: 14.0),
                        )
                      : Container(),
                  gameRef.isPowerUsed
                      ? Container()
                      : const Text(
                          'Ghost Mode not used +5',
                          style: TextStyle(fontSize: 14.0),
                        ),
                ],
              ),
            ),
            int.parse(gameRef.levelNumber) < 48
                ? SizedBox(
                    width: width / 3,
                    child: ElevatedButton(
                        onPressed: () async {
                          gameRef.overlays.remove(WinMenu.id);
                          gameRef.overlays.remove(LevelText.id);
                          gameRef.overlays.remove(PowerUpText.id);
                          gameRef.setCurrentFact();
                          gameRef.overlays.add(DidYouKnowScreen.id);
                          gameRef.loadNextLevel();
                          await Future.delayed(const Duration(seconds: 3), () {
                            gameRef.overlays.remove(DidYouKnowScreen.id);
                          });
                          gameRef.overlays.add(StartLevelMenu.id);
                        },
                        child: const Text('Next')),
                  )
                : Container(),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () async {
                    gameRef.overlays.remove(WinMenu.id);
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
                    gameRef.overlays.remove(WinMenu.id);
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
