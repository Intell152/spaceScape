import 'package:flutter/material.dart';

import '../screens/main_menu.dart';
import '../game/space_scape_game.dart';
import '../widgets/pause_button.dart';

class GameOverMenu extends StatelessWidget {
  // ignore: constant_identifier_names
  static const String ID = 'GameOverMenu';
  final SpaceScapeGame gameRef;

  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              'Game Over',
              style: TextStyle(
                fontSize: 50,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 15,
                    color: Colors.white,
                    offset: Offset.zero,
                  ),
                  Shadow(
                    blurRadius: 20,
                    color: Colors.white,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              '${gameRef.playerData.score}',
              style: const TextStyle(
                fontSize: 35,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 15,
                    color: Colors.white,
                    offset: Offset.zero,
                  ),
                  Shadow(
                    blurRadius: 20,
                    color: Colors.white,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Current Score',
              style: TextStyle(
                fontSize: 35,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 15,
                    color: Colors.white,
                    offset: Offset.zero,
                  ),
                  Shadow(
                    blurRadius: 20,
                    color: Colors.white,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(GameOverMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Text('Restart'),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(GameOverMenu.ID);
                gameRef.reset();
                gameRef.resumeEngine();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                  ),
                );
              },
              child: const Text('Exit'),
            ),
          ),
        ],
      ),
    );
  }
}
