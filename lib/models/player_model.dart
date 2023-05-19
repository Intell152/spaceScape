import 'package:flutter/material.dart';

class Player extends ChangeNotifier {
  final String color;

  Player({
    required this.color,
  });

  Player.fromMap(Map<String, dynamic> map) : color = map['color'];

  static Map<String, dynamic> defaultData = {
    'color': 'playerShip1_orange.png',
  };
}
