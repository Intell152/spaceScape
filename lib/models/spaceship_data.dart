// ignore_for_file: constant_identifier_names

class SpaceShip {
  final String name;
  final int cost;
  final double speed;
  final int spriteId;
  final String assetPath;
  final int level;

  const SpaceShip({
    required this.cost,
    required this.name,
    required this.speed,
    required this.spriteId,
    required this.assetPath,
    required this.level,
  });

  static SpaceShip getSpaceShipByType(SpaceShipType spaceShipType) {
    return spaceShips[spaceShipType] ?? spaceShips.entries.first.value;
  }

  static const Map<SpaceShipType, SpaceShip> spaceShips = {
    SpaceShipType.Canary: SpaceShip(
      name: 'Canary',
      cost: 0,
      speed: 300,
      spriteId: 1,
      assetPath: 'playerShip1_red.png',
      level: 1,
    ),
    SpaceShipType.Condor: SpaceShip(
      name: 'Condor',
      cost: 1000,
      speed: 350,
      spriteId: 2,
      assetPath: 'playerShip2_red.png',
      level: 2,
    ),
    SpaceShipType.Falcon: SpaceShip(
      name: 'Falcon',
      cost: 1500,
      speed: 400,
      spriteId: 3,
      assetPath: 'playerShip3_red.png',
      level: 3,
    ),
    SpaceShipType.UFO: SpaceShip(
      name: 'UFO',
      cost: 0,
      speed: 450,
      spriteId: 4,
      assetPath: 'playerShip4_red.png',
      level: 4,
    ),
  };
}

enum SpaceShipType {
  Canary,
  Condor,
  Falcon,
  UFO,
}
