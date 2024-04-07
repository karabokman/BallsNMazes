import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Painter extends BodyComponent {
  final Vector2 startPosition;
  final String colour;

  Painter({
    required this.colour,
    required this.startPosition,
  });

  @override
  Future<void> onLoad() {
    priority = 10;
    renderBody = false;
    // add sprite animation to the painter object/body
    final img = game.images.fromCache('Painter/$colour-Brush.png');
    final animation = SpriteAnimation.fromFrameData(
        img,
        SpriteAnimationData.sequenced(
            amount: 17, stepTime: 0.03, textureSize: Vector2.all(30)));
    add(SpriteAnimationComponent(animation: animation, anchor: Anchor.center));
    return super.onLoad();
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 4;
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    final bodyDef = BodyDef(
      userData: this, // To be able to determine object in collision
      position: startPosition,
      type: BodyType.static,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
