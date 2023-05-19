import 'package:flame/components.dart';
import 'package:space_scape/game/space_scape_game.dart';

class Enemy extends SpriteComponent with HasGameRef<SpaceScapeGame>{
  final Vector2 _moveDirection = Vector2(0, 1);
  final double _speed = 100;

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }

  @override
  void update(double dt) {
    position += _moveDirection * _speed * dt;
    if (position.y > gameRef.size.y) {
      removeFromParent();
    } else if ((position.x < size.x / 2) ||
        (position.x > (gameRef.size.x - size.x / 2))) {
      // Enemy is going outside vertical screen bounds, flip its x direction.
      _moveDirection.x *= -1;
    }
    super.update(dt);
  }
}