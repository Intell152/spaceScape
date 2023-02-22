import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/enemy/enemy.dart';
import 'package:space_scape/game/command.dart';
import 'package:space_scape/player/bullet.dart';
import 'package:space_scape/player/player.dart';
import 'package:space_scape/enemy/enemy_manager.dart';

class SpaceScapeGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late Player _player;
  late EnemyManager _enemyManager;
  late final JoystickComponent _joystick;
  late TextComponent _playerScore;
  late TextComponent _playerHealth;
  Color _healthColor = const Color.fromARGB(255, 17, 166, 45);

  late Sprite _playerSprite;
  late Sprite _enemySprite;
  late Sprite redLaser;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);

  bool _isAlreadyLoaded = false;

  @override
  Future<void> onLoad() async {
    if (!_isAlreadyLoaded) {
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

      _playerScore = TextComponent(
          text: 'Score: 0',
          position: Vector2(size.x - 10, 0),
          textRenderer: TextPaint(
              style: const TextStyle(
            color: Color.fromARGB(255, 243, 240, 210),
            fontSize: 16,
            fontFamily: 'BungeeInline',
          )));

      _playerScore.anchor = Anchor.topRight;
      _playerScore.positionType =
          PositionType.viewport; //Prevents Camera's Transformation efects
      add(_playerScore);

      _playerHealth = TextComponent(
          text: 'Health: 100%',
          position: Vector2(10, 0),
          textRenderer: TextPaint(
              style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontFamily: 'BungeeInline',
          )));

      _playerHealth.positionType =
          PositionType.viewport; //Prevents Camera's Transformation efects
      add(_playerHealth);

      _isAlreadyLoaded = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var command in _commandList) {
      for (var component in children) {
        command.execute(component);
      }
    }

    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    _playerScore.text = 'Score: ${_player.score}';
    _playerHealth.text = 'HP: ${_player.health}%';
  }

  @override
  void render(Canvas canvas) {
    if (_player.health == 30) {
      _healthColor = const Color.fromARGB(255, 226, 43, 40);
    } else if (_player.health == 60) {
      _healthColor = const Color.fromARGB(255, 232, 201, 30);
    }

    canvas.drawRRect(
        RRect.fromLTRBR(
            5, 2, _player.health.toDouble(), 18, const Radius.circular(10)),
        Paint()..color = _healthColor);

    super.render(canvas);
  }

  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  void reset() {
    _player.reset();
    _enemyManager.reset();

    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });

    children.whereType<Bullet>().forEach((bullet) {
      bullet.removeFromParent();
    });
  }
}
