import 'dart:math';
import 'package:flame/components.dart';

import '../game/meteor.dart';
import '../game/space_scape_game.dart';

class MeteorManager extends Component with HasGameRef<SpaceScapeGame> {
  late Timer _timer;
  late Timer _freezeTimer;
  Random random = Random();

  MeteorManager() : super() {
    _timer = Timer(
      5,
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
    MeteorComponent meteor = MeteorComponent()
      ..sprite = Sprite(gameRef.images.fromCache('meteorBrown_tiny1.png'))
      ..position =
          Vector2(random.nextDouble() * (gameRef.size.x - Vector2(32, 32).x), 0)
      ..size = Vector2(32, 32);

    meteor.anchor = Anchor.center;
    add(meteor);
  }
}
