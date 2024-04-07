import 'dart:ui';

import 'package:flame/components.dart' as fl;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:balls_n_mazes/components/sfx_player.dart';

class Checkpoint extends BodyComponent {
  final Vector2 startPosition;
  final List<Vector2> vertices;

  Checkpoint({
    required this.vertices,
    required this.startPosition,
  }) : super() {
    _stateChangeTimer = fl.Timer(
      60,
      onTick: () => _changeCurrentState(),
      repeat: true,
    );
  }
  // Change colour stae timer
  late fl.Timer _stateChangeTimer;
  // All colours a checkpoint can have.
  final List<String> colours = ['Blue', 'Green', 'Red', 'Yellow'];
  // Current colour state
  late String currentColour;
  // Old colour state
  late String oldColour;
  // Current Sprite
  late fl.Sprite _currentSprite;
  // Sfx player
  late SfxPlayerComponent _audioplayer;

  @override
  Future<void> onLoad() {
    renderBody = false;
    //Randomise the colour selection of the checkpoint.
    colours.shuffle();
    //Set the current clour state of the checkpoint.
    currentColour = colours.first;
    //Set current sprite.
    _currentSprite =
        fl.Sprite(game.images.fromCache('Checkpoint/$currentColour.png'));
    // initialize audio player
    _audioplayer = SfxPlayerComponent();
    add(_audioplayer);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _currentSprite.render(canvas);
    super.render(canvas);
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..set(vertices);
    // Set the fixture of the body as a sensor so that it doesn't generate a collision response.
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    final bodyDef = BodyDef(
      userData: this, // To be able to determine object in collision
      position: startPosition,
      type: BodyType.static,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    _stateChangeTimer.update(dt);
    super.update(dt);
  }

  _changeCurrentState() {
    // Play sprite change audio
    _audioplayer.playSfx('blip.wav');
    //Randomise the colour selection of the checkpoint.
    colours.shuffle();
    //Set the current clour state of the checkpoint.
    final String newColour = colours.first;
    // Set new Sprite
    if (currentColour == newColour) {
      currentColour = colours.last;
      _currentSprite =
          fl.Sprite(game.images.fromCache('Checkpoint/$currentColour.png'));
    } else {
      currentColour = newColour;
      _currentSprite =
          fl.Sprite(game.images.fromCache('Checkpoint/$currentColour.png'));
    }
  }
}
