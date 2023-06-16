import 'package:flutter/material.dart';

import '../models/player_model.dart';

class PlayerProvider extends ChangeNotifier {
  late Player playerData = Player.fromMap(Player.defaultData);

  Player getPlayerData(Player playerData) {
    playerData = Player(
      color: playerData.color,
      score: playerData.score,
      spaceShipPath: playerData.spaceShipPath,
      bulletPath: playerData.bulletPath,
    );

    return playerData;
  }

  Player getPlayerColor(Color color) {

    if (color == Colors.orange) {
      playerData.color = 'orange';
      playerData.spaceShipPath = 'playerShip1_orange.png';
      playerData.bulletPath = 'laserOrange01.png';
    } else if (color == Colors.blue) {
      playerData.color = 'blue';
      playerData.spaceShipPath = 'playerShip1_blue.png';
      playerData.bulletPath = 'laserBlue01.png';
    } else if (color == Colors.green) {
      playerData.color = 'green';
      playerData.spaceShipPath = 'playerShip1_green.png';
      playerData.bulletPath = 'laserGreen01.png';
    }

    return playerData;
  }
}
