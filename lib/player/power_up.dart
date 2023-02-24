import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/enemy/enemy_manager.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/enemy/enemy.dart';
import 'package:space_scape/game/command.dart';
import 'package:space_scape/player/player.dart';
import 'package:space_scape/player/power_up_manager.dart';

abstract class PowerUp extends SpriteComponent
    with HasGameRef<SpaceScapeGame>, CollisionCallbacks {
  late Timer _timer;

  Sprite getSprite();
  void onActivation();

  PowerUp({
    Vector2? position,
    Vector2? size,
    Sprite? sprite,
  }) : super(position: position, size: size, sprite: sprite) {
    _timer = Timer(3, onTick: removeFromParent);
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  @override
  void onMount() {
    final shape = CircleHitbox.relative(
      0.5,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);

    sprite = getSprite();

    _timer.start();
    super.onMount();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      onActivation();
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }
}

class Nuke extends PowerUp {
  Nuke({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('nuke.png'));
  }

  @override
  void onActivation() {
    final command = Command<Enemy>(action: (enemy) {
      enemy.removeFromParent();
    });

    gameRef.addCommand(command);
  }
}

class Health extends PowerUp {
  Health({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('health.png'));
  }

  @override
  void onActivation() {
    final command = Command<Player>(action: (player) {
      player.increasehealth(10);
    });

    gameRef.addCommand(command);
  }
}

class Freeze extends PowerUp {
  Freeze({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('pause.png'));
  }

  @override
  void onActivation() {
    final command = Command<Enemy>(action: (enemy) {
      enemy.freeze();
    });

    final command2 = Command<EnemyManager>(action: (enemyManager) {
      enemyManager.freeze();
    });

    final command3 = Command<PowerUpManager>(action: (powerUp) {
      powerUp.freeze();
    });

    gameRef.addCommand(command);
    gameRef.addCommand(command2);
    gameRef.addCommand(command3);
  }
}

class MultiFire extends PowerUp {
  MultiFire({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('multi_fire.png'));
  }

  @override
  void onActivation() {
    final command = Command<Player>(action: (player) {
      player.shootMultipleBullets();
    });

    gameRef.addCommand(command);
  }
}
