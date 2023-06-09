import 'package:flutter/material.dart';

import '../game/space_scape_game.dart';
import '../screens/pause_menu.dart';

class PauseButton extends StatelessWidget {
  // ignore: constant_identifier_names
  static const String ID = 'PauseButton';
  final SpaceScapeGame gameRef;

  const PauseButton({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TextButton(
        child: const Icon(
          Icons.pause_circle_outline_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          gameRef.pauseEngine();
          gameRef.overlays.add(PauseMenu.ID);
          gameRef.overlays.remove(PauseButton.ID);
        },
      ),
    );
  }
}
