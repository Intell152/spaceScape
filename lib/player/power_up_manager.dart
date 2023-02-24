import 'dart:math';
import 'package:flame/components.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/player/power_up.dart';

// ignore: constant_identifier_names
enum PowerUpTypes { Health, Freeze, Nuke, MultiFire }

class PowerUpManager extends Component with HasGameRef<SpaceScapeGame> {
  late Timer _spawnTimer;
  late Timer _freezeTimer;

  Random random = Random();

  static final Map<PowerUpTypes,
      PowerUp Function(Vector2 position, Vector2 size)> _powerUpMap = {
    PowerUpTypes.Health: (position, size) => Health(
          position: position,
          size: size,
        ),
    PowerUpTypes.Freeze: (position, size) => Freeze(
          position: position,
          size: size,
        ),
    PowerUpTypes.Nuke: (position, size) => Nuke(
          position: position,
          size: size,
        ),
    PowerUpTypes.MultiFire: (position, size) => MultiFire(
          position: position,
          size: size,
        ),
  };

  PowerUpManager() : super() {
    _spawnTimer = Timer(
      5,
      onTick: _spawnPowerUp,
      repeat: true,
    );
    _freezeTimer = Timer(
      2,
      onTick: () => _spawnTimer.start(),
    );
  }

  void _spawnPowerUp() {
    Vector2 initialSize = Vector2(32, 32);
    Vector2 position = Vector2(
      random.nextDouble() * (gameRef.size.x - initialSize.x),
      random.nextDouble() * (gameRef.size.y - (initialSize.y * 6)),
    );

    position.clamp(
      Vector2.zero() + initialSize / 2,
      gameRef.size - initialSize / 2,
    );

    int randomIndex = random.nextInt(PowerUpTypes.values.length);
    final fn = _powerUpMap[PowerUpTypes.values.elementAt(randomIndex)];

    var powerUp = fn?.call(position, initialSize / 2.5);
    powerUp?.anchor = Anchor.center;
    
    if (powerUp != null) {
     gameRef.add(powerUp); 
    }
  }

  @override
  void onMount() {
    super.onMount();
    _spawnTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer.update(dt);
    _freezeTimer.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _spawnTimer.stop();
  }

  void reset() {
    _spawnTimer.stop();
    _spawnTimer.start();
  }

  void freeze() {
    _spawnTimer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}
