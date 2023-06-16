import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';

import '../game/bullet.dart';
import '../game/player.dart';
import '../game/space_scape_game.dart';

class MeteorComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceScapeGame> {
  final Vector2 _moveDirection = Vector2(0, 1);
  late double _speed = 50;
  late Timer _freezeTimer;
  late CircleHitbox _shape;
  int _hitPoints = 10;

  MeteorComponent() : super() {
    _speed = 50;
    _freezeTimer = Timer(2, onTick: () {
      _speed = 50;
    });
  }

  @override
  void onMount() {
    _shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );

    add(_shape);
    super.onMount();
  }

  @override
  void update(double dt) {
    if (_hitPoints <= 0) {
      
      sprite = Sprite(gameRef.images.fromCache('destroyedMeteor.png'));
      _shape.collisionType = CollisionType.inactive;

      add(RemoveEffect(delay: 0.1));
    }

    _freezeTimer.update(dt);

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
    if (other is BulletComponent){
      FlameAudio.play('RockDestroy.mp3');
      _hitPoints = 0;
    } else if (other is PlayerComponent) {
      FlameAudio.play('Crash.mp3');
      _hitPoints = 0;
    }
    super.onCollision(intersectionPoints, other);
  }
}
