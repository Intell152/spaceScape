import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/enemy/enemy.dart';
import 'package:space_scape/game/game.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceScapeGame> {
  JoystickComponent joystick;
  //TODO: Este valor puede asignarce dinamicamente para aumentar o reducir velocidad
  // ignore: prefer_final_fields
  double _speed = 300;

  Player({
    required this.joystick,
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(
          sprite: sprite,
          position: position,
          size: size,
        );

  // @override
  // void render(Canvas canvas) { //View shape colision boxes
  //   super.render(canvas);

  //   renderDebugMode(canvas);
  // }

  @override
  void onMount() {
    super.onMount();

    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy) {
      print('Player hit enemy');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(joystick.relativeDelta * _speed * dt);
  }
}
