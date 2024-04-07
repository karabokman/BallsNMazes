import 'dart:ui';

import 'package:flame/components.dart' as fl;
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:balls_n_mazes/components/sfx_player.dart';
import 'package:balls_n_mazes/components/checkpoint.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/components/painter.dart';
import 'package:balls_n_mazes/models/balls_details.dart';
import 'package:balls_n_mazes/models/level_data.dart';
import 'package:balls_n_mazes/models/player_data.dart';
import 'package:balls_n_mazes/widgets/overlays/pause_button.dart';
import 'package:balls_n_mazes/widgets/overlays/power_up_text.dart';
import 'package:balls_n_mazes/widgets/overlays/win_menu.dart';
import 'package:provider/provider.dart';

class Player extends BodyComponent with ContactCallbacks, TapCallbacks {
  final double radius;
  final Vector2 startPosition;
  final fl.JoystickComponent joystick;
  //Initialize Ball type
  BallType ballType;
  Ball _ball;

  Player(
      {required this.ballType,
      required this.startPosition,
      required this.joystick,
      this.radius = 15})
      : _ball = Ball.getBallByType(ballType),
        super() {
    _powerUpTimer = fl.Timer(
      1,
      onTick: () => _resetSprite(),
      autoStart: false,
    );
  }

  // Check if player has reached the checkpoint and completed the level
  bool reachedCheckpoint = false;
  // The current colour state of the player
  String currentState = 'White';
  // Last colour State
  String lastState = 'White';
  // Sprite used for drawing the player object to the screen
  late fl.Sprite _currentSprite;
  // Checks if Power Up is active
  bool isPowerUpActive = false;
  // Power up timer
  late fl.Timer _powerUpTimer;
  // Player data
  late PlayerData _playerData;
  //Audiop player
  late SfxPlayerComponent _audioPlayerComponent;

  @override
  Future<void> onLoad() {
    priority = 5;
    renderBody = false;
    _currentSprite = fl.Sprite(game.images
        .fromCache('Players/${_ball.name}/$currentState (30x30).png'));

    // initialize audio player
    _audioPlayerComponent = SfxPlayerComponent();
    add(_audioPlayerComponent);
    return super.onLoad();
  }

  @override
  void onMount() {
    _playerData = Provider.of<PlayerData>(game.buildContext!, listen: false);
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    //Drawing the player sprite on the screen
    _currentSprite.render(canvas,
        anchor: fl.Anchor.center, size: Vector2.all(30));
    super.render(canvas);
  }

  @override
  Body createBody() {
    final shape = CircleShape();
    shape.radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.5,
      friction: 0.4,
    );

    final bodyDef = BodyDef(
      userData: this,
      position: startPosition,
      angularDamping: 0.8,
      type: BodyType.dynamic,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    // Handling player movement
    if (!reachedCheckpoint) {
      if (!joystick.delta.isZero()) {
        body.applyLinearImpulse(joystick.delta * _ball.speed * dt);
      } else {
        body.setAwake(false);
      }
    }
    if (isPowerUpActive) {
      // Set filter to ignore collisions
      for (var fixture in body.fixtures) {
        final filter = Filter()
          ..categoryBits = 0x0000
          ..maskBits = 0x0000;
        fixture.filterData = filter;
      }
    } else {
      // Set normal filter back
      for (var fixture in body.fixtures) {
        final filter = Filter()
          ..categoryBits = 0x0001
          ..maskBits = 0xFFFF;
        fixture.filterData = filter;
      }
    }
    _powerUpTimer.update(dt);
    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact) {
    //Handling player collision detection
    if (other is Checkpoint) {
      if (currentState == other.currentColour) {
        // Play level complete sound
        _audioPlayerComponent.playSfx('checkpoint.wav');
        game.pauseEngine();
        game.overlays.remove(PauseButton.id);
        // Get componets of player's parents
        ancestors().forEach((component) {
          if (component is MazeGame) {
            // Get current level's number
            int levelNumber = int.parse(component.levelNumber);
            // Stop the stopwatch
            component.stopTimeTaken();
            // initialize the time taken
            int timeTaken = component.getStopwatch();
            // Get current level data
            final LevelData currentLevelData =
                LevelData.levelsData.elementAt(levelNumber - 1);
            // Credit coins for winning level
            if (timeTaken <= currentLevelData.goldTime) {
              _playerData.coins += 15;
            } else if (timeTaken <= currentLevelData.silverTime) {
              _playerData.coins += 10;
            } else {
              _playerData.coins += 5;
            }
            if (!_playerData.isLevelCompleted(levelNumber)) {
              _playerData.coins += 5;
              component.isFirstTime = true;
            }
            if (!component.isPowerUsed) {
              _playerData.coins += 5;
            }

            if (_playerData.isLevelCompleted(levelNumber)) {
              int preTimeTaken = _playerData.getTimeTaken(levelNumber);
              if (timeTaken < preTimeTaken) {
                //Add level to completed levels
                _playerData.markLevelCompleted(levelNumber, timeTaken);
                // set new best time
                component.newBestTime = true;
                _playerData.coins += 5;
              }
            } else {
              //Add level to completed levels
              _playerData.markLevelCompleted(levelNumber, timeTaken);
            }
            _playerData.save();
          }
        });
        reachedCheckpoint = true;
        game.overlays.add(WinMenu.id);
      }
    }
    if (other is Painter) {
      if (currentState != other.colour && currentState != 'Ghost') {
        // Play painting sound
        _audioPlayerComponent.playSfx('paint.wav');
        // Set last state
        lastState = currentState;
        // Set new colour state
        currentState = other.colour;
        // Set new sprite
        _currentSprite = fl.Sprite(game.images
            .fromCache('Players/${_ball.name}/$currentState (30x30).png'));
      }
    }
    super.beginContact(other, contact);
  }

  void _resetSprite() {
    // Set power up to off
    isPowerUpActive = false;
    //Reset current state
    currentState = lastState;
    // Set power up sprite
    _currentSprite = fl.Sprite(game.images
        .fromCache('Players/${_ball.name}/$currentState (30x30).png'));
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_playerData.powerUps >= 1 && !isPowerUpActive) {
      // Play ghost mode sound
      _audioPlayerComponent.playSfx('ghostmode.wav');
      // Decrease Power Ups
      _playerData.powerUps -= 1;
      _playerData.save();
      // decrese power ups text
      ancestors().forEach((element) {
        if (element is MazeGame) {
          element.overlays.remove(PowerUpText.id);
          element.decreasePowerUps();
          element.isPowerUsed = true;
          element.overlays.add(PowerUpText.id);
        }
      });
      // Handle Power up Timer
      _powerUpTimer.stop();
      _powerUpTimer.start();
      // Set last State
      lastState = currentState;
      // Set new State
      currentState = 'Ghost';
      // Set is active to true
      isPowerUpActive = true;
      // Set power up sprite
      _currentSprite = fl.Sprite(
          game.images.fromCache('Players/Common/$currentState (30x30).png'));
    }
    super.onTapUp(event);
  }

  void setBallType(BallType newBallType) {
    ballType = newBallType;
    _ball = Ball.getBallByType(ballType);
  }
}
