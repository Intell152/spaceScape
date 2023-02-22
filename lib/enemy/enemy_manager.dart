import 'dart:math';
import 'package:flame/components.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/enemy/enemy.dart';

class EnemyManager extends Component with HasGameRef<SpaceScapeGame> {
  late Timer _timer;
  Sprite enemySprite;
  Random random = Random();

  EnemyManager({required this.enemySprite}) : super() {
    _timer = Timer(1, onTick: _spawnEnemy, repeat: true);
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(32, 32);
    Vector2 position =
        Vector2(random.nextDouble() * (gameRef.size.x - initialSize.x), 0);

    position.clamp(
      Vector2.zero() + initialSize / 2,
      gameRef.size - initialSize / 2,
    );

    Enemy enemy =
        Enemy(sprite: enemySprite, size: initialSize, position: position);

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
}
