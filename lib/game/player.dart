import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:provider/provider.dart';
import 'package:space_scape/game/meteor.dart';
import 'package:space_scape/providers/player_provider.dart';

import 'bullet.dart';
import '../game/enemy.dart';
import '../game/space_scape_game.dart';

class PlayerComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceScapeGame> {
  late PlayerProvider _playerProvider;
  late BulletComponent _bullet;
  late String _bulletPath;
  late Timer _attackTimer;
  bool _isVisible = true;
  int _health = 100;
  int get health => _health; //get values ​​without modifying
  int get score => _playerProvider.playerData.score; //get values ​​without modifying

  PlayerComponent() : super() {
    _attackTimer = Timer(
      .5,
      onTick: () {
        createBullet(_bulletPath);
      },
      repeat: true,
    );
  }

  @override
  void render(Canvas canvas) {
    if (_isVisible) super.render(canvas);
  }

  @override
  void onMount() {
    _attackTimer.stop();

    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );

    add(shape);

    _playerProvider =
        Provider.of<PlayerProvider>(gameRef.buildContext!, listen: false);

    super.onMount();
  }

  @override
  void update(double dt) {
    _attackTimer.update(dt);
    super.update(dt);
  }

  @override
  void onRemove() {
    _attackTimer.stop();
    super.onRemove();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is EnemyComponent) {
      gameRef.camera.shake(intensity: 10);

      _health -= 10;
      if (_health <= 0) {
        _health = 0;

        _isVisible = false;
      }
    }

    if (other is MeteorComponent) {
      gameRef.camera.shake(intensity: 10);

      _health -= 10;
      if (_health <= 0) {
        _health = 0;

        _isVisible = false;
      }
    }
  }

  void move(Vector2 delta) {
    double newX = position.x + delta.x;
    double newY = position.y + delta.y;
    double screenWidth = gameRef.size.x;
    double screenHeight = gameRef.size.y;

    if (newX >= 0.0 &&
        newX <= screenWidth &&
        newY >= 0.0 &&
        newY <= screenHeight) {
      position.add(delta);
    }
  }

  void attack(String bulletPath) {
    _bulletPath = bulletPath;
    createBullet(_bulletPath);
    _attackTimer.start();
  }

  void stopAttack() {
    _attackTimer.stop();
  }

  void createBullet(String bulletPath) {
    _bullet = BulletComponent()
      ..sprite = Sprite(gameRef.images.fromCache(bulletPath))
      ..position = position.clone()
      ..size = Vector2(20, 20);

    // _bullet.position.x = _bullet.position.x;
    _bullet.anchor = Anchor.center;
    gameRef.add(_bullet);
  }

  void addScore(int points) {
    _playerProvider.playerData.score += points;
  }

  void reset() {
    _isVisible = true;
    // _playerData.currentScore = 0;
    _health = 100;
    position = gameRef.size / 2;
  }
}
