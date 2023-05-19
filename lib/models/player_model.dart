import 'package:flutter/material.dart';

class Player extends ChangeNotifier {
  final String color;
  final String spaceShipPath;
  final String bulletPath;

  Player({
    required this.color,
    required this.spaceShipPath,
    required this.bulletPath,
  });

  Player.fromMap(Map<String, dynamic> map)
      : color = map['color'],
        spaceShipPath = map['spaceShipPath'],
        bulletPath = map['bulletPath'];

  static Map<String, dynamic> defaultData = {
    'color': 'orange',
    'spaceShipPath': 'playerShip1_orange.png',
    'bulletPath': 'playerShip1_orange.png',
  };
}
