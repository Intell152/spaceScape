import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/widgets/overlays/pause_button.dart';
import 'package:space_scape/widgets/overlays/pause_menu.dart';

SpaceScapeGame _spaceScapeGame = SpaceScapeGame();

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false ,
        child: GameWidget(
          game: _spaceScapeGame,
          initialActiveOverlays: const [
            PauseButton.ID,
          ],
          overlayBuilderMap: {
            PauseButton.ID: (BuildContext context, SpaceScapeGame gameRef) =>  PauseButton(gameRef: gameRef),
            PauseMenu.ID: (BuildContext context, SpaceScapeGame gameRef) =>  PauseMenu(gameRef: gameRef),
          },
        ),
      ),
    );
  }
}
