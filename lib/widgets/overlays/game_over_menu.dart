import 'package:flutter/material.dart';
import 'package:space_scape/game/game.dart';
import 'package:space_scape/screens/main_menu.dart';
import 'package:space_scape/widgets/overlays/pause_button.dart';

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
          
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
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