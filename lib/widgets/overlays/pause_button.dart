import 'package:flutter/material.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/widgets/overlays/pause_menu.dart';

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
        child: Icon(
          Icons.pause_circle_outline,
          color: Colors.grey.shade400,
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
