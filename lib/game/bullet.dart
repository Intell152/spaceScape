import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:space_scape/game/meteor.dart';

import 'enemy.dart';

class BulletComponent extends SpriteComponent with CollisionCallbacks {
  final double _speed = 450;
  Vector2 direction = Vector2(0, -1);

  @override
  void onMount() {
    super.onMount();

    FlameAudio.play('LaserBeam.mp3');

    final shape = CircleHitbox.relative(
      0.4,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );

    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is EnemyComponent || other is MeteorComponent) removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += direction * _speed * dt;

    if (position.y < 0) {
      removeFromParent();
    }
  }
}
