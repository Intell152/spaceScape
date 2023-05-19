import 'package:flutter/material.dart';

import '../models/player_model.dart';

class PlayerProvider extends ChangeNotifier {
  late Player playerData = Player(
    color: 'orange',
    spaceShipPath: 'playerShip1_orange.png',
    bulletPath: 'laserOrange01.png',
  );

  Player getPlayerData(Player playerData) {
    playerData = Player(
      color: playerData.color,
      spaceShipPath: playerData.spaceShipPath,
      bulletPath: playerData.bulletPath,
    );

    return playerData;
  }

  Player getPlayerColor(Color color) {
    String playerColor = '';
    String spaceShipPath = '';
    String bulletPath = '';
    
    if (color == Colors.orange) {
      playerColor = 'orange';
      spaceShipPath = 'playerShip1_orange.png';
      bulletPath = 'laserOrange01.png';
    } else if (color == Colors.blue) {
      playerColor = 'blue';
      spaceShipPath = 'playerShip1_blue.png';
      bulletPath = 'laserBlue01.png';
    } else if (color == Colors.green) {
      playerColor = 'green';
      spaceShipPath = 'playerShip1_green.png';
      bulletPath = 'laserGreen01.png';
    }

    playerData = Player(
      color: playerColor,
      spaceShipPath: spaceShipPath,
      bulletPath: bulletPath,
    );

    return playerData;
  }
}
