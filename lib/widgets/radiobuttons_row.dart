import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/player_provider.dart';

class RadioButtonsRow extends StatefulWidget {
  const RadioButtonsRow({Key? key}) : super(key: key);

  @override
  State<RadioButtonsRow> createState() => _RadioButtonsRowState();
}

class _RadioButtonsRowState extends State<RadioButtonsRow> {
  int _highlighted = 1;

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          // SpaceShip Orange
          padding: const EdgeInsets.all(8.0),
          child: InkResponse(
            onTap: () {
              FlameAudio.play('selection.ogg');
              playerProvider.getPlayerData('playerShip1_orange.png');
              setState(() {
                _highlighted = 1;
              });
            },
            child: Column(
              children: [
                Image.asset('assets/images/playerShip1_orange.png'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _highlighted == 1 ? Colors.red : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  width: 15.0,
                  height: 15.0,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
        Padding(
          // SpaceShip Green
          padding: const EdgeInsets.all(8.0),
          child: InkResponse(
            onTap: () {
              FlameAudio.play('selection.ogg');
              playerProvider.getPlayerData('playerShip1_green.png');
              setState(() {
                _highlighted = 2;
              });
            },
            child: Column(
              children: [
                Image.asset('assets/images/playerShip1_green.png'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _highlighted == 2
                        ? Colors.green[600]
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  width: 15.0,
                  height: 15.0,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
        Padding(
          // SpaceShip Blue
          padding: const EdgeInsets.all(8.0),
          child: InkResponse(
            onTap: () {
              FlameAudio.play('selection.ogg');
              playerProvider.getPlayerData('playerShip1_blue.png');
              setState(() {
                _highlighted = 3;
              });
            },
            child: Column(
              children: [
                Image.asset('assets/images/playerShip1_blue.png'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _highlighted == 3
                        ? Colors.blue[600]
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  width: 15.0,
                  height: 15.0,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
