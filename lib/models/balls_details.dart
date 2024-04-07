import 'package:hive/hive.dart';

part 'balls_details.g.dart';

class Ball {
  final String name;
  final int cost;
  final double speed;
  final String assetPath;

  const Ball({
    required this.name,
    required this.cost,
    required this.speed,
    required this.assetPath,
  });
  static Ball getBallByType(BallType ballType) {
    return balls[ballType] ?? balls.entries.first.value;
  }

  static const Map<BallType, Ball> balls = {
    BallType.plain: Ball(
      name: 'Plain',
      cost: 0,
      speed: 5000,
      assetPath: 'assets/images/Players/Plain/Default.png',
    ),
    BallType.beach: Ball(
      name: 'Beach',
      cost: 150,
      speed: 5560,
      assetPath: 'assets/images/Players/Beach/Default.png',
    ),
    BallType.bowling: Ball(
      name: 'Bowling',
      cost: 280,
      speed: 4000,
      assetPath: 'assets/images/Players/Bowling/Default.png',
    ),
    BallType.cricket: Ball(
      name: 'Cricket',
      cost: 350,
      speed: 6200,
      assetPath: 'assets/images/Players/Cricket/Default.png',
    ),
    BallType.base: Ball(
      name: 'Base',
      cost: 400,
      speed: 6100,
      assetPath: 'assets/images/Players/Base/Default.png',
    ),
    BallType.soccer: Ball(
      name: 'Soccer',
      cost: 500,
      speed: 6000,
      assetPath: 'assets/images/Players/Soccer/Default.png',
    ),
    BallType.basket: Ball(
      name: 'Basket',
      cost: 560,
      speed: 5500,
      assetPath: 'assets/images/Players/Basket/Default.png',
    ),
    BallType.tennis: Ball(
      name: 'Tennis',
      cost: 780,
      speed: 7500,
      assetPath: 'assets/images/Players/Tennis/Default.png',
    ),
    BallType.pool: Ball(
      name: 'Pool',
      cost: 1100,
      speed: 9000,
      assetPath: 'assets/images/Players/Pool/Default.png',
    ),
  };
}

@HiveType(typeId: 1)
enum BallType {
  @HiveField(0)
  plain,

  @HiveField(1)
  beach,

  @HiveField(2)
  bowling,

  @HiveField(3)
  cricket,

  @HiveField(4)
  base,

  @HiveField(5)
  soccer,

  @HiveField(6)
  basket,

  @HiveField(7)
  tennis,

  @HiveField(8)
  pool,
}
