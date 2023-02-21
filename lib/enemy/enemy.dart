import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/player/bullet.dart';
import 'package:space_scape/player/player.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceScapeGame> {
  //TODO: Este valor puede asignarce dinamicamente para aumentar o reducir velocidad
  // ignore: prefer_final_fields
  double _speed = 200;

    final _random = Random();

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 400;
  }

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
                    //TODO: Cambiuar color de acuerdo a la nave
                    paint: Paint()
                      ..color = const Color.fromARGB(255, 201, 196, 196)))));

      gameRef.add(destroyEffect);
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
