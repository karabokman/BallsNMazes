import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_world.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:balls_n_mazes/components/painter.dart';
import 'package:balls_n_mazes/components/player.dart';
import 'package:balls_n_mazes/components/checkpoint.dart';
import 'package:balls_n_mazes/components/wall.dart';
import 'package:balls_n_mazes/models/balls_details.dart';

class Level extends Forge2DWorld {
  final JoystickComponent joystick;
  final String levelNumber;
  final BallType ballType;
  Level(
      {required this.levelNumber,
      required this.joystick,
      required this.ballType});
  late TiledComponent level;
  late Player player;

  @override
  FutureOr<void> onLoad() async {
    //Get the level data from assets directory.d
    level = await TiledComponent.load('Level-$levelNumber.tmx', Vector2.all(8));
    //Add the level as a background of the screen.
    add(level);
    //add objects like the player,painter and checkpoint to the screen.
    _spawningObjects();
    //add the walls to the screen for collision detection.
    _addWalls();

    return super.onLoad();
  }

  void _addWalls() {
    //Get the wall layer which has data used to all the walls at the correct location
    //so that they align with the background
    final wallPointsLayer = level.tileMap.getLayer<ObjectGroup>('Walls');
    if (wallPointsLayer != null) {
      for (final wallPoint in wallPointsLayer.objects) {
        //All walls are polygon shape
        if (wallPoint.isPolygon) {
          final vertices =
              wallPoint.polygon.map((p) => Vector2(p.x, p.y)).toList();
          final wall =
              Wall(vertices: vertices, startPosition: wallPoint.position);
          add(wall);
        }
      }
    }
  }

  void _spawningObjects() {
    //Get location of the player, painter and checkpoint
    // from the spawnpoint layer of the tiled map
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            //Add the player
            player = Player(
              ballType: ballType,
              startPosition: (spawnPoint.position + Vector2.all(15)),
              joystick: joystick,
            );
            add(player);
            break;
          case 'Checkpoint':
            //Add the checkpoint
            if (spawnPoint.isPolygon) {
              final vertices =
                  spawnPoint.polygon.map((p) => Vector2(p.x, p.y)).toList();
              final checkpoint = Checkpoint(
                vertices: vertices,
                startPosition: spawnPoint.position,
              );
              add(checkpoint);
            }
            break;
          case 'Painter':
            // Add the painter
            final colour = spawnPoint.properties.getValue('colour') as String;
            final painter = Painter(
                colour: colour,
                startPosition: (spawnPoint.position + Vector2.all(15)));
            add(painter);
            break;
          default:
        }
      }
    }
  }
}
