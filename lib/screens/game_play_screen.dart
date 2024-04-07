import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/models/player_data.dart';
import 'package:balls_n_mazes/widgets/overlays/did_you_know_screen.dart';
import 'package:balls_n_mazes/widgets/overlays/game_over_menu.dart';
import 'package:balls_n_mazes/widgets/overlays/level_text.dart';
import 'package:balls_n_mazes/widgets/overlays/pause_button.dart';
import 'package:balls_n_mazes/widgets/overlays/pause_menu.dart';
import 'package:balls_n_mazes/widgets/overlays/power_up_text.dart';
import 'package:balls_n_mazes/widgets/overlays/start_level_menu.dart';
import 'package:balls_n_mazes/widgets/overlays/win_menu.dart';
import 'package:provider/provider.dart';

class GamePlayScreen extends StatelessWidget {
  final String levelNum;
  const GamePlayScreen({super.key, required this.levelNum});

  @override
  Widget build(BuildContext context) {
    final playerData = Provider.of<PlayerData>(context, listen: false);
    return Scaffold(
        body: PopScope(
            canPop: false,
            child: GameWidget(
              game: MazeGame(
                  levelNumber: levelNum,
                  ballType: playerData.ballType,
                  powerUps: playerData.powerUps),
              initialActiveOverlays: const [
                DidYouKnowScreen.id,
              ],
              overlayBuilderMap: {
                PauseButton.id: (BuildContext context, MazeGame gameRef) =>
                    PauseButton(gameRef: gameRef),
                PauseMenu.id: (BuildContext context, MazeGame gameRef) =>
                    PauseMenu(gameRef: gameRef),
                WinMenu.id: (BuildContext context, MazeGame gameRef) =>
                    WinMenu(gameRef: gameRef),
                LevelText.id: (BuildContext context, MazeGame gameRef) =>
                    LevelText(gameRef: gameRef),
                DidYouKnowScreen.id: (BuildContext context, MazeGame gameRef) =>
                    DidYouKnowScreen(gameRef: gameRef),
                StartLevelMenu.id: (BuildContext context, MazeGame gameRef) =>
                    StartLevelMenu(gameRef: gameRef),
                PowerUpText.id: (BuildContext context, MazeGame gameRef) =>
                    PowerUpText(gameRef: gameRef),
                GameOverMenu.id: (BuildContext context, MazeGame gameRef) =>
                    GameOverMenu(gameRef: gameRef),
              },
            )));
  }
}
