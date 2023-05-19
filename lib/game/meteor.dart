import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/game/bullet.dart';
import 'package:space_scape/game/space_scape_game.dart';

class MeteorComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceScapeGame> {
  final Vector2 _moveDirection = Vector2(0, 1);
  final double _speed = 50;

  @override
  void onMount() {
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );

    add(shape);
    super.onMount();
  }

  @override
  void update(double dt) {
    position += _moveDirection * _speed * dt;
    if (position.y > gameRef.size.y) {
      removeFromParent();
    } else if ((position.x < size.x / 2) ||
        (position.x > (gameRef.size.x - size.x / 2))) {
      // Enemy is going outside vertical screen bounds, flip its x direction.
      _moveDirection.x *= -1;
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BulletComponent) {
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}