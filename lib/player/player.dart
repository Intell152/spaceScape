import 'dart:math';
import 'bullet.dart';
import 'package:flame/particles.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/enemy/enemy.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceScapeGame> {
  JoystickComponent joystick;
  //TODO: Este valor puede asignarce dinamicamente para aumentar o reducir velocidad
  // ignore: prefer_final_fields
  double _speed = 300;
  int _score = 0;
  int get score => _score; //get values ​​without modifying

  int _health = 100;
  int get health => _health; //get values ​​without modifying

  final _random = Random();

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(0.5, -0.5)) * 200;
  }

  Player({
    required this.joystick,
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(
          sprite: sprite,
          position: position,
          size: size,
        );

  // @override
  // void render(Canvas canvas) { //View shape colision boxes
  //   super.render(canvas);

  //   renderDebugMode(canvas);
  // }

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
  void update(double dt) {
    super.update(dt);

    position.add(joystick.relativeDelta * _speed * dt);

    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );

    final motionTail = ParticleSystemComponent(
        particle: Particle.generate(
            count: 8,
            lifespan: 0.1,
            generator: (i) => AcceleratedParticle(
                acceleration: getRandomVector(),
                speed: getRandomVector(),
                position: (position.clone() + Vector2(0, size.y / 2)),
                child: CircleParticle(
                    radius: 0.5,
                    //TODO: Cambiar color de acuerdo a la nave
                    paint: Paint()
                      ..color = const Color.fromARGB(255, 255, 126, 34)))));

    gameRef.add(motionTail);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy) {
      gameRef.camera.shake(intensity: 10);

      _health -= 10;
      if (_health <= 0) {
        _health = 0;
      }
    }
  }

  void attack() {
    Bullet bullet = Bullet(
      sprite: gameRef.redLaser,
      position: position.clone(),
      size: Vector2(20, 20),
    );

    bullet.anchor = Anchor.center;
    gameRef.add(bullet);
  }

  void addToScore(int points) {
    _score += points;
  }

  void reset() {
    _score = 0;
    _health = 100;
    position = gameRef.size / 2;
  }
}
