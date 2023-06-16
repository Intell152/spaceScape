import 'dart:math';
import 'package:flame/components.dart';
import 'package:provider/provider.dart';

import '../game/enemy.dart';
import '../models/enemy_model.dart';
import '../game/space_scape_game.dart';
import '../providers/player_provider.dart';

class EnemyManager extends Component with HasGameRef<SpaceScapeGame> {
  late Timer _timer;
  late Timer _freezeTimer;
  Random random = Random();

  EnemyManager() : super() {
    _timer = Timer(
      2,
      onTick: _spawn,
      repeat: true,
    );
    _freezeTimer = Timer(
      2,
      onTick: () => _timer.start(),
    );
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    _freezeTimer.update(dt);
    super.update(dt);
  }

  @override
  void onRemove() {
    _timer.stop();
    super.onRemove();
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

  void _spawn() {
    int currentScore =
        Provider.of<PlayerProvider>(gameRef.buildContext!, listen: false).playerData.score;
    int maxLevel = mapScoreToMaxEnemyLevel(currentScore);

    final enemyData = _enemyList.elementAt(random.nextInt(maxLevel));

    EnemyComponent enemy = EnemyComponent(enemyData: enemyData)
      ..sprite = Sprite(gameRef.images.fromCache(enemyData.shipPath))
      ..position =
          Vector2(random.nextDouble() * (gameRef.size.x - Vector2(32, 32).x), 0)
      ..size = Vector2(32, 32);

    enemy.anchor = Anchor.center;
    gameRef.add(enemy);
  }

  int mapScoreToMaxEnemyLevel(int currentScore) {
    int level = 1;

    if (currentScore > 1500) {
      level = 4;
    } else if (currentScore > 500) {
      level = 3;
    } else if (currentScore > 100) {
      level = 2;
    }

    return level;
  }

  static const List<Enemy> _enemyList = [
    Enemy(
      speed: 200,
      shipPath: 'enemyBlack1.png',
      level: 1,
      hMove: false,
      healt: 10,
      valuePoints: 1,
    ),
    Enemy(
      speed: 250,
      shipPath: 'enemyBlack2.png',
      level: 2,
      hMove: true,
      healt: 20,
      valuePoints: 2,
    ),
    Enemy(
      speed: 300,
      shipPath: 'enemyBlack3.png',
      level: 3,
      hMove: false,
      healt: 20,
      valuePoints: 2,
    ),
    Enemy(
      speed: 250,
      shipPath: 'enemyBlack4.png',
      level: 4,
      hMove: true,
      healt: 30,
      valuePoints: 3,
    ),
    Enemy(
      speed: 400,
      shipPath: 'enemyBlack5.png',
      level: 5,
      hMove: false,
      healt: 20,
      valuePoints: 4,
    ),
  ];
}
