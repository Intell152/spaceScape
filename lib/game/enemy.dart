import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../game/player.dart';
import '../game/space_scape_game.dart';
import 'bullet.dart';

class EnemyComponent extends SpriteComponent
    with HasGameRef<SpaceScapeGame>, CollisionCallbacks {
  late Timer _freezeTimer;
  final Vector2 _moveDirection = Vector2(0, 1);
  double _speed = 100;
  int _hitPoints = 10;
  late CircleHitbox _shape;

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

  final _random = Random();

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 400;
  }

  Vector2 getRandomDirection() {
    return (Vector2.random(_random) - Vector2(0.5, -1)).normalized();
  }

  EnemyComponent() : super() {
    _speed = 100;
    _freezeTimer = Timer(2, onTick: () {
      _speed = 100;
    });
  }

  @override
  void onMount() {
    super.onMount();

    _shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(_shape);
    add(_hpText);
  }

  @override
  void update(double dt) {
    _hpText.text = '$_hitPoints HP';
    if (_hitPoints <= 0) {
      sprite = Sprite(gameRef.images.fromCache('destroyedShip01.png'));
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
    super.onCollision(intersectionPoints, other);

    if (other is BulletComponent) {
      // _hitPoints -= other.level * 10;
      _hitPoints = 0;
    } else if (other is PlayerComponent) {
      _hitPoints = 0;
    }
  }
}
