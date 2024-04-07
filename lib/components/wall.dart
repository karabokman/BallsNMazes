import 'package:flame_forge2d/flame_forge2d.dart';

class Wall extends BodyComponent {
  final Vector2 startPosition;
  final List<Vector2> vertices;

  Wall({
    required this.vertices,
    required this.startPosition,
  }) : super() {
    renderBody = false;
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..set(vertices);
    final fixtureDef = FixtureDef(shape, friction: 0.3, density: 100);
    final bodyDef = BodyDef(
      userData: this, // To be able to determine object in collision
      position: startPosition,
      type: BodyType.static,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
