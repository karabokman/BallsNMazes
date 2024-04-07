import 'package:flutter/material.dart';
import 'package:balls_n_mazes/models/balls_details.dart';
import 'package:hive/hive.dart';
import 'package:balls_n_mazes/models/level_data.dart';

part 'player_data.g.dart';

@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  static const String playerDataBox = 'PlayerDataBox';
  static const String playerDataKey = 'PlayerData';

  //The ball type of the player's current ball.
  @HiveField(0)
  BallType ballType;
  //All balls owned by the player.
  @HiveField(1)
  final List<BallType> ownedBalls;
  // Number of coins the player has.
  @HiveField(2)
  int coins;
  //All levels completed by the player
  @HiveField(3)
  final Map<int, int> completedLevels;
  //The number of power ups a player has
  @HiveField(4)
  int powerUps;

  PlayerData({
    required this.ballType,
    required this.ownedBalls,
    required this.coins,
    required this.completedLevels,
    required this.powerUps,
  });

  PlayerData.fromMap(Map<String, dynamic> map)
      : ballType = map['currentBallType'],
        ownedBalls = map['ownedBallTypes']
            .map((e) => e as BallType)
            .cast<BallType>()
            .toList(),
        coins = map['coins'],
        completedLevels =
            Map<int, int>.from(map['completedLevels'] as Map<dynamic, dynamic>)
                .cast<int, int>(),
        powerUps = map['powerUps'];

  static Map<String, dynamic> defaultData = {
    'currentBallType': BallType.plain,
    'ownedBallTypes': [BallType.plain],
    'coins': 0,
    'completedLevels': {},
    'powerUps': 1,
  };

  bool isOwned(BallType ballType) {
    return ownedBalls.contains(ballType);
  }

  bool canBuy(BallType ballType) {
    return (coins >= Ball.getBallByType(ballType).cost);
  }

  bool isEquiped(BallType newBallType) {
    return (ballType == newBallType);
  }

  void buy(BallType ballType) {
    if (canBuy(ballType) && !isOwned(ballType)) {
      coins -= Ball.getBallByType(ballType).cost;
      ownedBalls.add(ballType);
      notifyListeners();
      save();
    }
  }

  void equip(BallType newBallType) {
    ballType = newBallType;
    notifyListeners();
    save();
  }

  bool canBuyPowerUp() {
    return coins >= 20;
  }

  void buyPowerUp() {
    if (canBuyPowerUp()) {
      coins -= 20;
      powerUps += 1;
      notifyListeners();
      save();
    }
  }

  void markLevelCompleted(int levelNumber, int timeTaken) {
    completedLevels[levelNumber] = timeTaken;
    notifyListeners();
    save();
  }

  int getTimeTaken(int levelNumber) {
    return completedLevels[levelNumber] ?? 0;
  }

  String stopwatchToString(int levelNumber) {
    int milliseconds = getTimeTaken(levelNumber);
    int seconds = milliseconds ~/ 1000;
    String secStr = '${seconds % 60}';
    int minutes = seconds ~/ 60;
    String minStr = '${minutes % 60}';
    int hours = minutes ~/ 60;

    return hours != 0
        ? "${hours.toString().padLeft(2, '0')}:${minStr.padLeft(2, '0')}:${secStr.padLeft(2, '0')}"
        : "${minStr.padLeft(2, '0')}:${secStr.padLeft(2, '0')}";
  }

  String getBadge(int levelNumber) {
    String result = '';
    int timeTaken = getTimeTaken(levelNumber);
    final LevelData currentLevelData =
        LevelData.levelsData.elementAt(levelNumber - 1);
    if (timeTaken <= currentLevelData.goldTime) {
      result = 'Gold';
    } else if (timeTaken <= currentLevelData.silverTime) {
      result = 'Silver';
    } else {
      result = 'Bronze';
    }
    return result;
  }

  bool isLevelCompleted(int levelNumber) {
    return completedLevels.containsKey(levelNumber);
  }

  bool isLevelOpen(int levelNumber) {
    return (levelNumber - completedLevels.length) <= 1;
  }
}
