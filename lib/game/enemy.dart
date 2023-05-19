import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
// import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/game/player.dart';

import '../game/space_scape_game.dart';
import 'bullet.dart';

class EnemyComponent extends SpriteComponent
    with HasGameRef<SpaceScapeGame>, CollisionCallbacks {
  final Vector2 _moveDirection = Vector2(0, 1);
  final double _speed = 100;
  int _hitPoints = 10;
  late Image imagende;

  final TextComponent _hpText = TextComponent(
    text: '10 HP',
    position: Vector2(0, -12),
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'BungeeInline',
      ),
    ),
  );

  @override
  void onMount() {
    super.onMount();

    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
    add(_hpText);
  }

  @override
  void update(double dt) {
    _hpText.text = '$_hitPoints HP';
    if (_hitPoints <= 0) {
      
      sprite = Sprite(gameRef.images.fromCache('destroyedShip01.png'));
      add(RemoveEffect(delay: 0.05));

      // final command = Command<Player>(action: (player) {
      //   player.addToScore(enemyData.killPoints);
      // });

      // gameRef.addCommand(command);
    }

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
    super.onCollision(intersectionPoints, other);

    if (other is BulletComponent) {
      // _hitPoints -= other.level * 10;
      _hitPoints = 0;
    } else if (other is PlayerComponent) {
      _hitPoints = 0;
    }
  }
}
