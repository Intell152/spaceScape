import 'dart:math';
import 'package:flame/components.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/enemy/enemy.dart';
import 'package:space_scape/models/enemy_data.dart';

class EnemyManager extends Component with HasGameRef<SpaceScapeGame> {
  late Timer _timer;
  late Timer _freezeTimer;
  
  Random random = Random();

  EnemyManager() : super() {
    _timer = Timer(
      1,
      onTick: _spawnEnemy,
      repeat: true,
    );
    _freezeTimer = Timer(
      2,
      onTick: () => _timer.start(),
    );
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(32, 32);
    Vector2 position = Vector2(
      random.nextDouble() * (gameRef.size.x - initialSize.x),
      0,
    );

    position.clamp(
      Vector2.zero() + initialSize / 2,
      gameRef.size - initialSize / 2,
    );

    final enemyData = _enemyDataList.elementAt(random.nextInt(_enemyDataList.length));

    Enemy enemy = Enemy(
      sprite: Sprite(gameRef.images.fromCache(enemyData.spritePath)),
      size: initialSize,
      position: position,
      enemyData: enemyData,
    );

    enemy.anchor = Anchor.center;
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    _freezeTimer.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }

  void freeze() {
    _timer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }

  static const List<EnemyData> _enemyDataList = [
    EnemyData(
      speed: 200,
      spritePath: 'enemyBlack1.png',
      level: 1,
      hMove: false,
      killPoints: 1,
    ),
    EnemyData(
      speed: 250,
      spritePath: 'enemyBlack2.png',
      level: 2,
      hMove: true,
      killPoints: 1,
    ),
    EnemyData(
      speed: 300,
      spritePath: 'enemyBlack3.png',
      level: 3,
      hMove: false,
      killPoints: 2,
    ),
    EnemyData(
      speed: 350,
      spritePath: 'enemyBlack4.png',
      level: 4,
      hMove: true,
      killPoints: 3,
    ),
    EnemyData(
      speed: 400,
      spritePath: 'enemyBlack5.png',
      level: 5,
      hMove: false,
      killPoints: 1,
    ),
  ];
}
