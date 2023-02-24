import 'dart:math';
import 'package:provider/provider.dart';
import 'package:space_scape/models/player_data.dart';
import 'package:space_scape/models/spaceship_data.dart';

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

  int _score = 0;
  int get score => _score; //get values ​​without modifying

  int _health = 100;
  int get health => _health; //get values ​​without modifying

  SpaceShipType spaceShipType;
  // ignore: unused_field
  SpaceShip _spaceShip;

  late PlayerData _playerData;

  // ignore: unused_field
  bool _shootMultipleBullets = false;
  late Timer _powerUpTimer;

  final _random = Random();

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(0.5, -0.5)) * 200;
  }

  Player({
    required this.joystick,
    required this.spaceShipType,
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  })  : _spaceShip = SpaceShip.getSpaceShipByType(spaceShipType),
        super(sprite: sprite, position: position, size: size) {
    _powerUpTimer = Timer(
      4,
      onTick: () => _shootMultipleBullets = false,
    );
  }

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

    _playerData = Provider.of<PlayerData>(gameRef.buildContext!, listen: false);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _powerUpTimer.update(dt);

    position.add(joystick.relativeDelta * _spaceShip.speed * dt);

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
            paint: Paint()..color = const Color.fromARGB(255, 255, 126, 34),
          ),
        ),
      ),
    );

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
                //TODO: Cambiar color de acuerdo a la nave
                paint: Paint()..color = const Color.fromARGB(255, 255, 126, 34),
              ),
            ),
          ),
        );

        gameRef.add(destroyEffect);
      }
    }
  }

  void attack() {
    Bullet bullet = Bullet(
      sprite: Sprite(gameRef.images.fromCache('laserRed01.png')),
      position: position.clone(),
      size: Vector2(20, 20),
    );

    bullet.anchor = Anchor.center;
    gameRef.add(bullet);

    if (_shootMultipleBullets) {
      for (var i = -1; i < 2; i += 2) {
        Bullet bullet = Bullet(
          sprite: Sprite(gameRef.images.fromCache('laserRed01.png')),
          position: position.clone(),
          size: Vector2(20, 20),
        );

        bullet.anchor = Anchor.center;
        bullet.direction.rotate(i * pi / 6);
        gameRef.add(bullet);
      }
    }
  }

  void addToScore(int points) {
    _score += points;
    _playerData.money += points;
  }

  void increasehealth(int points) {
    _health += points;
    if (_health > 100) {
      _health = 100;
    }
  }

  void reset() {
    _score = 0;
    _health = 100;
    position = gameRef.size / 2;
  }

  void setSpaceShiptype(SpaceShipType spaceShipType) {
    this.spaceShipType = spaceShipType;
    _spaceShip = SpaceShip.getSpaceShipByType(spaceShipType);
    sprite = Sprite(gameRef.images.fromCache(_spaceShip.assetPath));
  }

  void shootMultipleBullets() {
    _shootMultipleBullets = true;
    _powerUpTimer.stop();
    _powerUpTimer.start();
  }
}
