import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/player/bullet.dart';
import 'package:space_scape/player/player.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceScapeGame> {
  //TODO: Este valor puede asignarce dinamicamente para aumentar o reducir velocidad
  // ignore: prefer_final_fields
  double _speed = 200;

  Enemy({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    // angle = pi; pi = 180 degrees
  }

  @override
  void onMount() {
    super.onMount();

    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2 ,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Bullet || other is Player) {
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0, 1) * _speed * dt;

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
