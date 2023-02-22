import 'package:flutter/material.dart';
import 'package:space_scape/screens/game_play.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Space Scape',
                style: TextStyle(fontSize: 50, color: Colors.black, shadows: [
                  Shadow(
                    blurRadius: 15,
                    color: Colors.white,
                    offset: Offset.zero,
                  ),
                  Shadow(
                    blurRadius: 20,
                    color: Colors.white,
                    offset: Offset.zero,
                  )
                ]),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const GamePlay()));
                },
                child: const Text('Play'),
              ),
            ),
            SizedBox(
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
