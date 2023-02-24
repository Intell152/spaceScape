import 'package:flutter/material.dart';
import 'package:space_scape/models/spaceship_data.dart';

class PlayerData extends ChangeNotifier {
  SpaceShipType spaceShipType;
  final List<SpaceShipType> ownedSpaceShips;
  final int highScore;
  int money;

  PlayerData({
    required this.spaceShipType,
    required this.ownedSpaceShips,
    required this.highScore,
    required this.money,
  });

  PlayerData.fromMap(Map<String, dynamic> map)
      : spaceShipType = map['currentSpaceShipType'],
        ownedSpaceShips = map['ownedSpaceShipTypes']
            .map((e) => e as SpaceShipType)
            .cast<SpaceShipType>()
            .toList(),
        highScore = map['highScore'],
        money = map['money'];

  static Map<String, dynamic> defaultData = {
    'currentSpaceShipType': SpaceShipType.Canary,
    'ownedSpaceShipTypes': [],
    'highScore': 0,
    'money': 0,
  };

  bool isOwned(SpaceShipType spaceShipType) {
    return ownedSpaceShips.contains(spaceShipType);
  }

  bool canBuy(SpaceShipType spaceShipType) {
    return (money >= SpaceShip.getSpaceShipByType(spaceShipType).cost);
  }

  bool isEquipped(SpaceShipType spaceShipType) {
    return (this.spaceShipType == spaceShipType);
  }

  void buy(SpaceShipType spaceShipType) {
    if (canBuy(spaceShipType) && (!isOwned(spaceShipType))) {
      money -= SpaceShip.getSpaceShipByType(spaceShipType).cost;
      ownedSpaceShips.add(spaceShipType);
      notifyListeners();
    }
  }

  void equip(SpaceShipType spaceShipType) {
    this.spaceShipType = spaceShipType;
    notifyListeners();
  }
}
