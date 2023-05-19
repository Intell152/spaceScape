import 'package:flame/components.dart';
import 'package:space_scape/game/space_scape_game.dart';

class PlayerComponent extends SpriteComponent with HasGameRef<SpaceScapeGame> {
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
}
