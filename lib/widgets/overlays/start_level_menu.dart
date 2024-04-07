import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/models/player_data.dart';
import 'package:balls_n_mazes/widgets/overlays/level_text.dart';
import 'package:balls_n_mazes/widgets/overlays/pause_button.dart';
import 'package:balls_n_mazes/widgets/overlays/power_up_text.dart';
import 'package:provider/provider.dart';

class StartLevelMenu extends StatelessWidget {
  static const String id = 'StartLevelMenu';
  final MazeGame gameRef;
  const StartLevelMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    final playerData = Provider.of<PlayerData>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Level ${gameRef.levelNumber}',
                  style: const TextStyle(fontSize: 26.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  playerData.isLevelCompleted(int.parse(gameRef.levelNumber))
                      ? Text(
                          'Best Time: ${playerData.stopwatchToString(int.parse(gameRef.levelNumber))}',
                          style: const TextStyle(fontSize: 20.0))
                      : const Text('Best Time: --:--',
                          style: TextStyle(fontSize: 20.0)),
                  playerData.isLevelCompleted(int.parse(gameRef.levelNumber))
                      ? Text(
                          'Medal: ${playerData.getBadge(int.parse(gameRef.levelNumber))}',
                          style: const TextStyle(fontSize: 18.0),
                        )
                      : const Text(
                          'Medal: ----',
                          style: TextStyle(fontSize: 18.0),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
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
                          style: const TextStyle(
                            fontSize: 14.0,
                          ))
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
                    gameRef.overlays.add(PauseButton.id);
                    gameRef.overlays.add(LevelText.id);
                    gameRef.overlays.add(PowerUpText.id);
                    gameRef.overlays.remove(StartLevelMenu.id);
                    gameRef.resetTimer();
                  },
                  child: const Text('Start')),
            ),
          ],
        ),
      ),
    );
  }
}
