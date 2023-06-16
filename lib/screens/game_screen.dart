import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_scape/screens/game_over_menu.dart';

import '../screens/pause_menu.dart';
import '../providers/player_provider.dart';
import '../widgets/pause_button.dart';
import '../game/space_scape_game.dart';

class GameScreen extends StatelessWidget{
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    // ignore: no_leading_underscores_for_local_identifiers
    SpaceScapeGame _spaceScape = SpaceScapeGame(playerData: playerProvider.playerData);

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: _spaceScape,
          initialActiveOverlays: const [
            PauseButton.ID
          ],
          overlayBuilderMap: {
            PauseButton.ID: (BuildContext context, SpaceScapeGame gameRef) =>  PauseButton(gameRef: gameRef),
            PauseMenu.ID: (BuildContext context, SpaceScapeGame gameRef) =>  PauseMenu(gameRef: gameRef),
            GameOverMenu.ID: (BuildContext context, SpaceScapeGame gameRef) => GameOverMenu(gameRef: gameRef),
          },
        ),
      ),
    );
  }
}
