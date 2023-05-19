import 'dart:async';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'player.dart';
import '../models/player_model.dart';
import '../controllers/meteor_manager.dart';
import '../controllers/enemy_manager.dart';

class SpaceScapeGame extends FlameGame with PanDetector {
  late PlayerComponent _player;
  bool _isAlreadyLoaded = false;

  late MeteorManager _meteorManager;
  late EnemyManager _enemyManager;
  late Player playerData;

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

      // Add Player to de game
      _player = PlayerComponent()
        ..size = Vector2(32, 32)
        ..position = size / 2
        ..sprite = playerSprite;
      add(_player);

      _meteorManager = MeteorManager();
      add(_meteorManager);

      _enemyManager = EnemyManager();
      add(_enemyManager);

      _isAlreadyLoaded = true;
    }
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
}
