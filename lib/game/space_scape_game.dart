import 'dart:async';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'player.dart';
import '../game/bullet.dart';
import '../models/player_model.dart';
import '../controllers/meteor_manager.dart';
import '../controllers/enemy_manager.dart';

class SpaceScapeGame extends FlameGame with PanDetector, HasCollisionDetection {
  late PlayerComponent _player;
  late MeteorManager _meteorManager;
  late EnemyManager _enemyManager;
  late Player playerData;
  late TextComponent _playerScore;
  late TextSpan _playerHealth;
  Color _healthColor = const Color.fromARGB(255, 17, 166, 45);
  bool _isAlreadyLoaded = false;

  SpaceScapeGame({
    required this.playerData,
  });

  @override
  Future<FutureOr<void>> onLoad() async {
    if (!_isAlreadyLoaded) {
      await images.loadAllImages();
      final playerSprite = Sprite(images.fromCache(playerData.spaceShipPath));

      ParallaxComponent backGround = await ParallaxComponent.load(
        [
          ParallaxImageData('backGround.png'),
        ],
        repeat: ImageRepeat.repeatY,
        baseVelocity: Vector2(0, -50),
        // velocityMultiplierDelta: Vector2(0, 1.5),
      );

      add(backGround);

      _playerScore = TextComponent(
        text: 'Score: 0',
        position: Vector2(size.x - 10, 0),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color.fromARGB(255, 243, 240, 210),
            fontSize: 16,
            fontFamily: 'BungeeInline',
          ),
        ),
      );

      _playerScore.anchor = Anchor.topRight;
      //Prevents Camera's Transformation efects
      _playerScore.positionType = PositionType.viewport;

      add(_playerScore);

      // Add Player to de game
      _player = PlayerComponent()
        ..size = Vector2(32, 32)
        ..position = size / 2
        ..sprite = playerSprite;

      _player.anchor = Anchor.center;
      add(_player);

      _meteorManager = MeteorManager();
      add(_meteorManager);

      _enemyManager = EnemyManager();
      add(_enemyManager);

      _isAlreadyLoaded = true;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_player.health == 30) {
      _healthColor = const Color.fromARGB(255, 226, 43, 40);
    } else if (_player.health == 60) {
      _healthColor = const Color.fromARGB(255, 232, 201, 30);
    }

    super.render(canvas);

    canvas.drawRRect(
      RRect.fromLTRBR(
        5,
        2,
        _player.health.toDouble(),
        // _healtText.toDouble(),
        18,
        const Radius.circular(10),
      ),
      Paint()..color = _healthColor,
    );

    // print('Game: ${_player.health}');

    _playerHealth = TextSpan(
      text: 'HP: ${_player.health}%',
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 16,
        fontFamily: 'BungeeInline',
      ),
    );
    final textPainter = TextPainter(
      text: _playerHealth,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 2));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.move(info.delta.game);
  }

  @override
  void onPanStart(DragStartInfo info) {
    _player.attack(playerData.bulletPath);
    super.onPanStart(info);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _player.stopAttack();
    super.onPanEnd(info);
  }

  void reset() {
    _player.reset();
    _enemyManager.reset();
    _meteorManager.reset();
    _healthColor = const Color.fromARGB(255, 17, 166, 45);

    children.whereType<EnemyManager>().forEach((enemy) {
      enemy.removeWhere((component) => true);
    });

    children.whereType<MeteorManager>().forEach((meteor) {
      meteor.removeWhere((component) => true);
    });

    children.whereType<BulletComponent>().forEach((bullet) {
      bullet.removeFromParent();
    });
  }
}
