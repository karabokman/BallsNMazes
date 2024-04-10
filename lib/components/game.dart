import 'dart:async';
import 'dart:math';
import 'package:balls_n_mazes/services/admob_service.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/audio_player_component.dart';
import 'package:balls_n_mazes/components/level.dart';
import 'package:balls_n_mazes/models/balls_details.dart';
import 'package:balls_n_mazes/models/level_data.dart';
import 'package:balls_n_mazes/widgets/overlays/did_you_know_screen.dart';
import 'package:balls_n_mazes/widgets/overlays/game_over_menu.dart';
import 'package:balls_n_mazes/widgets/overlays/pause_button.dart';
import 'package:balls_n_mazes/widgets/overlays/pause_menu.dart';
import 'package:balls_n_mazes/widgets/overlays/start_level_menu.dart';
import 'package:balls_n_mazes/models/did_you_know.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MazeGame extends Forge2DGame with DragCallbacks {
  String levelNumber;
  final BallType ballType;
  MazeGame(
      {required this.levelNumber,
      required this.ballType,
      required this.powerUps});
  late CameraComponent cam;
  late Level newWorld;
  late final JoystickComponent joystick;
  // Player power ups
  int powerUps;
  // Check if power up is used in the current level
  late bool isPowerUsed;
  // Check if it is the fisrt time completing the level
  late bool isFirstTime;
  // Check if it is new best time
  late bool newBestTime;
  // Stopwatch text
  late TextComponent timeText;
  // Audio player component
  late AudioPlayerComponent _audioPlayerComponent;
  //Stopwatch to record time taken to complete level
  final Stopwatch _stopWatch = Stopwatch();
  // Current did you know fact
  late DidYouKnow currentFact;
  // Interstitial ad
  InterstitialAd? _interstitialAd;
  // initialise background colour
  final Color _backgroundColour = Colors.teal;
  //set background colour
  @override
  Color backgroundColor() => _backgroundColour;

  @override
  FutureOr<void> onLoad() async {
    //Load all images into cache
    await images.loadAllImages();

    // Initialize current fact
    setCurrentFact();

    // Add audio player component
    _audioPlayerComponent = AudioPlayerComponent();
    add(_audioPlayerComponent);

    // Set the joystick component
    _setJoystick();

    // Pause game engine
    pauseEngine();

    await _loadLevel();

    timeText = TextComponent(
        text: '00:00',
        position: Vector2(size.x - 10, 10),
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 15),
        ))
      ..anchor = Anchor.topRight;
    add(timeText);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    timeText.text = getTimetaken();
    if (_stopWatch.elapsedMilliseconds >= 240000) {
      pauseEngine();
      stopTimeTaken();
      overlays.remove(PauseButton.id);
      overlays.add(GameOverMenu.id);
    }
    super.update(dt);
  }

  @override
  void onAttach() {
    _audioPlayerComponent.playBgm('background.mp3');
    super.onAttach();
  }

  @override
  void onDetach() {
    _audioPlayerComponent.stopbgm();
    super.onDetach();
  }

  @override
  void onMount() async {
    await Future.delayed(const Duration(seconds: 4), () {
      overlays.remove(DidYouKnowScreen.id);
    });
    overlays.add(StartLevelMenu.id);
    super.onMount();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (!newWorld.player.reachedCheckpoint) {
          pauseEngine();
          stopTimeTaken();
          overlays.remove(PauseButton.id);
          overlays.add(PauseMenu.id);
        }
        break;
    }
    super.lifecycleStateChange(state);
  }

  void _setJoystick() {
    //Joystick component
    joystick = JoystickComponent(
      knob: SpriteComponent(
          sprite: Sprite(images.fromCache('HUD/Knob.png')),
          size: Vector2.all(44)),
      background: SpriteComponent(
          sprite: Sprite(images.fromCache('HUD/Joystick.png')),
          size: Vector2.all(80)),
    );
  }

  String getTimetaken() {
    int milliseconds = getStopwatch();
    int seconds = milliseconds ~/ 1000;
    String secStr = '${seconds % 60}';
    int minutes = seconds ~/ 60;
    String minStr = '${minutes % 60}';
    int hours = minutes ~/ 60;

    return hours != 0
        ? "${hours.toString().padLeft(2, '0')}:${minStr.padLeft(2, '0')}:${secStr.padLeft(2, '0')}"
        : "${minStr.padLeft(2, '0')}:${secStr.padLeft(2, '0')}";
  }

  String getBadge() {
    String result = '';
    int timeTaken = getStopwatch();
    final LevelData currentLevelData =
        LevelData.levelsData.elementAt(int.parse(levelNumber) - 1);
    if (timeTaken <= currentLevelData.goldTime) {
      result = 'Gold +15';
    } else if (timeTaken <= currentLevelData.silverTime) {
      result = 'Silver +10';
    } else {
      result = 'Bronze +5';
    }
    return result;
  }

  String getTimeAsString(int millisecond) {
    int milliseconds = millisecond;
    int seconds = milliseconds ~/ 1000;
    String secStr = '${seconds % 60}';
    int minutes = seconds ~/ 60;
    String minStr = '${minutes % 60}';
    int hours = minutes ~/ 60;

    return hours != 0
        ? "${hours.toString().padLeft(2, '0')}:${minStr.padLeft(2, '0')}:${secStr.padLeft(2, '0')}"
        : "${minStr.padLeft(2, '0')}:${secStr.padLeft(2, '0')}";
  }

  String getGoldTime() {
    final LevelData currentLevelData =
        LevelData.levelsData.elementAt(int.parse(levelNumber) - 1);
    String result = getTimeAsString(currentLevelData.goldTime);
    return result;
  }

  String getSilverTime() {
    final LevelData currentLevelData =
        LevelData.levelsData.elementAt(int.parse(levelNumber) - 1);
    String result = getTimeAsString(currentLevelData.silverTime);
    return result;
  }

  int getStopwatch() {
    return _stopWatch.elapsedMilliseconds;
  }

  void stopTimeTaken() {
    _stopWatch.stop();
  }

  void continueTimer() {
    _stopWatch.start();
  }

  void resetTimer() {
    _stopWatch.reset();
    _stopWatch.start();
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);
    int levelNum = int.parse(levelNumber);
    levelNum++;
    levelNumber = '$levelNum';
    if (levelNum <= 48) {
      Future.delayed(const Duration(seconds: 1), () async {
        await _loadLevel();
      });
    }
  }

  void replayLevel() {
    removeWhere((component) => component is Level);

    Future.delayed(const Duration(seconds: 1), () async {
      await _loadLevel();
    });
  }

  Future<void> _loadLevel() async {
    // Initialize ad
    _createInterstitialAd();
    // Set power is used to false at the beginning of the level
    isPowerUsed = false;
    // Initially set is first time to false
    isFirstTime = false;
    // Initiallly set new best time to false
    newBestTime = false;
    // Initialize level world
    newWorld =
        Level(levelNumber: levelNumber, joystick: joystick, ballType: ballType);
    Level world = newWorld;

    // Set resolution of the world
    int levelNum = int.parse(levelNumber);
    if (levelNum <= 5) {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 416, height: 416);
    } else if (levelNum <= 9) {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 512, height: 512);
    } else if (levelNum <= 12) {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 605, height: 605);
    } else if (levelNum <= 20) {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 400, height: 400);
    } else if (levelNum <= 24) {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 496, height: 496);
    } else if (levelNum <= 32) {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 504, height: 504);
    } else if (levelNum <= 38) {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 584, height: 584);
    } else if (levelNum <= 48) {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 624, height: 624);
    }

    // Set camera anchor
    cam.viewfinder.anchor = Anchor.topLeft;
    // Add the camera and the world components
    addAll([cam, world]);
  }

  void decreasePowerUps() {
    powerUps -= 1;
  }

  void setCurrentFact() {
    currentFact = DidYouKnow.funFacts
        .elementAt(Random().nextInt(DidYouKnow.funFacts.length));
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdmobService.intertitialAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => _interstitialAd = ad,
            onAdFailedToLoad: ((error) => _interstitialAd = null)));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    joystick.position = event.canvasPosition;
    add(joystick);
    joystick.onDragStart(event);
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    joystick.onDragUpdate(event);
    super.onDragUpdate(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    joystick.onDragCancel(event);
    super.onDragCancel(event);
  }

  @override
  void onDragEnd(DragEndEvent event) async {
    joystick.onDragEnd(event);
    await Future.delayed(const Duration(milliseconds: 100), () {
      remove(joystick);
    });
    super.onDragEnd(event);
  }
}
