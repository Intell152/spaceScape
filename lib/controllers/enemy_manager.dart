import 'dart:math';
import 'package:flame/components.dart';

import '../game/enemy.dart';
import '../game/space_scape_game.dart';

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
    EnemyComponent enemy = EnemyComponent()
      ..sprite = Sprite(gameRef.images.fromCache('enemyBlack1.png'))
      ..position =
          Vector2(random.nextDouble() * (gameRef.size.x - Vector2(32, 32).x), 0)
      ..size = Vector2(32, 32);
      
    enemy.anchor = Anchor.center;
    add(enemy);
  }
}
