import 'package:flutter/material.dart';

import 'game_screen.dart';
import '../widgets/animated_text.dart';
import '../widgets/radiobuttons_row.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: AnimatedText(),
            ),
            Padding(
              // Select Player Color
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 5),
              child: const RadioButtonsRow(),
            ),
            SizedBox(
              // Start Game
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
                child: const Text('Play'),
              ),
            ),
            SizedBox(
              // Play Options
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Options'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
