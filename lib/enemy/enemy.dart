import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/game/command.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/models/enemy_data.dart';
import 'package:space_scape/player/bullet.dart';
import 'package:space_scape/player/player.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceScapeGame> {
  //TODO: Este valor puede asignarce dinamicamente para aumentar o reducir velocidad
  // double _speed;

  late Timer _freezeTimer;

  double _speed = 200;

  Vector2 _moveDirection = Vector2(0, 1);

  final EnemyData enemyData;

  final _random = Random();

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 400;
  }

  Vector2 getRandomDirection() {
    return (Vector2.random(_random) - Vector2(0.5, -1)).normalized();
  }

  Enemy({
    required this.enemyData,
    required Sprite? sprite,
    required Vector2? position,
    required Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    // angle = pi; pi = 180 degrees
    _speed = enemyData.speed;

    _freezeTimer = Timer(2, onTick: () {
      _speed = enemyData.speed;
    });

    if (enemyData.hMove) {
      _moveDirection = getRandomDirection();
    }
  }

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
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Bullet || other is Player) {
      removeFromParent();

      final command = Command<Player>(action: (player) {
        player.addToScore(10);
      });

      gameRef.addCommand(command);
    }
  }

  @override
  void onRemove() {
    if (position.y < gameRef.size.y) {
      final destroyEffect = ParticleSystemComponent(
        particle: Particle.generate(
          count: 20,
          lifespan: 0.1,
          generator: (i) => AcceleratedParticle(
            acceleration: getRandomVector(),
            speed: getRandomVector(),
            position: (position.clone()),
            child: CircleParticle(
              radius: 2,
              //TODO: Cambiar color de acuerdo a la nave
              paint: Paint()..color = const Color.fromARGB(255, 201, 196, 196),
            ),
          ),
        ),
      );

      gameRef.add(destroyEffect);
    }
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _freezeTimer.update(dt);

    // print('Update ${_speed}');
    position += _moveDirection * _speed * dt;

    if (position.y > gameRef.size.y) {
      removeFromParent();
    } else if ((position.x < size.x / 2) ||
        (position.x > (gameRef.size.x - size.x / 2))) {
      // Enemy is going outside vertical screen bounds, flip its x direction.
      _moveDirection.x *= -1;
    }
  }

  void freeze() {
    _speed = 0;
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}
