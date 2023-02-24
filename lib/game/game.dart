import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_scape/enemy/enemy.dart';
import 'package:space_scape/game/command.dart';
import 'package:space_scape/player/bullet.dart';
import 'package:space_scape/player/player.dart';
import 'package:space_scape/models/player_data.dart';
import 'package:space_scape/enemy/enemy_manager.dart';
import 'package:space_scape/models/spaceship_data.dart';
import 'package:space_scape/player/power_up.dart';
import 'package:space_scape/player/power_up_manager.dart';
import 'package:space_scape/widgets/overlays/game_over_menu.dart';
import 'package:space_scape/widgets/overlays/pause_button.dart';
import 'package:space_scape/widgets/overlays/pause_menu.dart';

class SpaceScapeGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late Player _player;
  late EnemyManager _enemyManager;
  late PowerUpManager _powerUpManager;
  late final JoystickComponent _joystick;
  late TextComponent _playerScore;
  late TextComponent _playerHealth;
  Color _healthColor = const Color.fromARGB(255, 17, 166, 45);


  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);

  bool _isAlreadyLoaded = false;

  static const spaceShipType = SpaceShipType.Canary;
  final spaceShip = SpaceShip.getSpaceShipByType(spaceShipType);

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

      // await images.load('playerShip1_red.png');
      // await images.load('playerShip2_red.png');
      // await images.load('playerShip3_red.png');
      // await images.load('playerShip4_red.png');
      // await images.load('enemyBlack2.png');
      // await images.load('laserRed01.png');
      // await images.loadAll('fileNames')
      await images.loadAllImages();

      // redLaser = Sprite(images.fromCache('laserRed01.png'));

      _joystick = JoystickComponent(
        anchor: Anchor.bottomLeft,
        position: Vector2(30, size.y - 50),
        background: CircleComponent(
          radius: 60,
          paint: Paint()..color = Colors.grey.withOpacity(0.5),
        ),
        knob: CircleComponent(
          radius: 30,
          paint: Paint()..color = const Color.fromARGB(255, 199, 196, 196),
        ),
      );

      add(_joystick);

      _player = Player(
        spaceShipType: spaceShipType,
        joystick: _joystick,
        // sprite: _playerSprite,
        sprite: Sprite(images.fromCache(spaceShip.assetPath)),
        size: Vector2(32, 32),
        position: size / 2,
      );

      _player.anchor = Anchor.center;
      add(_player);

      _enemyManager = EnemyManager();
      add(_enemyManager);

      _powerUpManager = PowerUpManager();
      add(_powerUpManager);

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
          ),
        ),
      );

      _playerScore.anchor = Anchor.topRight;
      //Prevents Camera's Transformation efects
      _playerScore.positionType = PositionType.viewport;

      add(_playerScore);

      _playerHealth = TextComponent(
        text: 'Health: 100%',
        position: Vector2(10, 0),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontFamily: 'BungeeInline',
          ),
        ),
      );

      //Prevents Camera's Transformation efects
      _playerHealth.positionType = PositionType.viewport;
      add(_playerHealth);

      _isAlreadyLoaded = true;
    }
  }

  @override
  void onAttach() {
    if (buildContext != null) {
      final playerData = Provider.of<PlayerData>(buildContext!, listen: false);

      _player.setSpaceShiptype(playerData.spaceShipType);
    }
    super.onAttach();
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

    if (_player.health <= 0 && (!camera.shaking)) {
      pauseEngine();
      overlays.remove(PauseButton.ID);
      overlays.add(GameOverMenu.ID);

      _player = Player(
        spaceShipType: spaceShipType,
        joystick: _joystick,
        // sprite: _playerSprite,
        sprite: Sprite(images.fromCache(spaceShip.assetPath)),
        size: Vector2(32, 32),
        position: size / 2,
      );

      _player.anchor = Anchor.center;

      add(_player);
    }
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
        5,
        2,
        _player.health.toDouble(),
        18,
        const Radius.circular(10),
      ),
      Paint()..color = _healthColor,
    );

    super.render(canvas);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (_player.health > 0) {
          pauseEngine();
          overlays.remove(PauseButton.ID);
          overlays.add(PauseMenu.ID);
        }
        break;
    }

    super.lifecycleStateChange(state);
  }

  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  void reset() {
    _player.reset();
    _enemyManager.reset();
    _powerUpManager.reset();
    _healthColor = const Color.fromARGB(255, 17, 166, 45);

    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });

    children.whereType<Bullet>().forEach((bullet) {
      bullet.removeFromParent();
    });

    children.whereType<PowerUp>().forEach((powerUp) {
      powerUp.removeFromParent();
    });
  }
}
