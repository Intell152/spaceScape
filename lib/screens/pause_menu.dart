import 'package:flutter/material.dart';

import '../game/space_scape_game.dart';
import '../widgets/pause_button.dart';
import 'main_menu.dart';

class PauseMenu extends StatelessWidget {
  // ignore: constant_identifier_names
  static const String ID = 'PauseMenu';
  final SpaceScapeGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              'Paused',
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
                gameRef.resumeEngine();
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
              },
              child: const Text('Resume'),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
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
                gameRef.overlays.remove(PauseMenu.ID);
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
