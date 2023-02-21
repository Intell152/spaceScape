import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/player/player.dart';
import 'package:space_scape/enemy/enemy_manager.dart';

class SpaceScapeGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late Player _player;
  late EnemyManager _enemyManager;
  late final JoystickComponent _joystick;

  late Sprite _playerSprite;
  late Sprite _enemySprite;
  late Sprite redLaser;

  @override
  Future<void> onLoad() async {
    // await images.load('sheet.png');
    // final spriteSheet = SpriteSheet.fromColumnsAndRows(
    //     image: images.fromCache('sheet.png'), columns: 10, rows: 13);

    // SpriteComponent player = SpriteComponent(
    //     sprite: spriteSheet.getSpriteById(3),
    //     size: Vector2(64, 64),
    //     position: size / 2 );

    await images.load('playerShip3_orange.png');
    await images.load('enemyBlack2.png');
    await images.load('laserRed01.png');

    _playerSprite = Sprite(images.fromCache('playerShip3_orange.png'));
    _enemySprite = Sprite(images.fromCache('enemyBlack2.png'));
    redLaser = Sprite(images.fromCache('laserRed01.png'));

    _joystick = JoystickComponent(
      anchor: Anchor.bottomLeft,
      position: Vector2(30, size.y - 50),
      background: CircleComponent(
        radius: 60,
        paint: Paint()..color = Colors.grey.withOpacity(0.5),
      ),
      knob: CircleComponent(
          radius: 30,
          paint: Paint()..color = const Color.fromARGB(255, 199, 196, 196)),
    );

    add(_joystick);

    _player = Player(
        joystick: _joystick,
        sprite: _playerSprite,
        size: Vector2(32, 32),
        position: size / 2);

    _player.anchor = Anchor.center;
    add(_player);

    _enemyManager = EnemyManager(enemySprite: _enemySprite);
    add(_enemyManager);

    final button = ButtonComponent(
      button: CircleComponent(
        radius: 30,
        paint: Paint()..color = Colors.white.withOpacity(0.5),
      ),
      anchor: Anchor.bottomRight,
      position: Vector2(size.x - 40, size.y - 50),
      onPressed: _player.attack,
    );
    
    add(button);
  }

  // @override
  // void onTapDown(TapDownInfo info) {
  //   super.onTapDown(info);

  //   if (!_joystick.isDragged) {
  //     Bullet bullet = Bullet(
  //       sprite: _redLaser,
  //       position: _player.position,
  //       size: Vector2(20, 20),
  //     );

  //     bullet.anchor = Anchor.center;
  //     add(bullet);
  //   }
  // }
}
