import 'package:flutter/material.dart';

class Player extends ChangeNotifier {
  String color;
  int score;
  String spaceShipPath;
  String bulletPath;

  Player({
    required this.color,
    required this.score,
    required this.spaceShipPath,
    required this.bulletPath,
  });

  Player.fromMap(Map<String, dynamic> map)
      : color = map['color'],
        score = map['score'],
        spaceShipPath = map['spaceShipPath'],
        bulletPath = map['bulletPath'];

  static Map<String, dynamic> defaultData = {
    'color': 'orange',
    'score': 0,
    'spaceShipPath': 'playerShip1_orange.png',
    'bulletPath': 'laserOrange01.png',
  };
}
