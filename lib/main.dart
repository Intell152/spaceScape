import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/game/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen(); // THis opens the app in fullscreen mode

  

  runApp(
    GameWidget(
      game: SpaceScapeGame()
    )
  );
}
