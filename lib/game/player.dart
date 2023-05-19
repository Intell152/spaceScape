import 'package:flame/components.dart';
import 'package:space_scape/game/space_scape_game.dart';

import 'bullet.dart';

class PlayerComponent extends SpriteComponent with HasGameRef<SpaceScapeGame> {
  late Bullet _bullet;

  late Timer _attackTimer;

  PlayerComponent() : super() {
    _attackTimer = Timer(
      .5,
      onTick: () {
        createBullet();
      },
      repeat: true,
    );
  }

  @override
  void onMount() {
    _attackTimer.stop();
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

  void move(Vector2 delta) {
    double newX = position.x + delta.x;
    double newY = position.y + delta.y;
    double screenWidth = gameRef.size.x;
    double screenHeight = gameRef.size.y;
    double componentSize = 32.0;

    if (newX >= 0.0 &&
        newX <= screenWidth - componentSize &&
        newY >= 0.0 &&
        newY <= screenHeight - componentSize) {
      position.add(delta);
    }
  }

  void attack() {
    createBullet();
    _attackTimer.start();
  }

  void stopAttack() {
    _attackTimer.stop();
  }

  void createBullet() {
    _bullet = Bullet()
      ..sprite = Sprite(gameRef.images.fromCache('laserRed01.png'))
      ..position = position.clone()
      ..size = Vector2(20, 20);

    _bullet.anchor = Anchor.center;
    gameRef.add(_bullet);
  }
}
