import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:space_scape/models/player_data.dart';
import 'package:space_scape/models/spaceship_data.dart';
import 'package:space_scape/screens/game_play.dart';
import 'package:space_scape/screens/main_menu.dart';

class SelectSpaceShip extends StatelessWidget {
  const SelectSpaceShip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              // padding: EdgeInsets.symmetric(vertical: 100),
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, bottom: 100),
              child: const Text(
                'Select',
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

            Consumer<PlayerData>(
              builder: (context, playerData, child) {
                final spaceShip =
                    SpaceShip.getSpaceShipByType(playerData.spaceShipType);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Ship: ${spaceShip.name}'),
                    Text('Money: ${playerData.money}'),
                  ],
                );
              },
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: CarouselSlider.builder(
                itemCount: SpaceShip.spaceShips.length,
                slideIndicator: CircularSlideIndicator(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  indicatorBackgroundColor: Colors.grey.shade700,
                  currentIndicatorColor: Colors.white,
                ),
                slideBuilder: (index) {
                  final spaceShip =
                      SpaceShip.spaceShips.entries.elementAt(index).value;

                  return Column(
                    children: [
                      Image.asset('assets/images/${spaceShip.assetPath}'),
                      Text(spaceShip.name),
                      Text('Speed: ${spaceShip.speed}'),
                      Text('Level: ${spaceShip.level}'),
                      Text('Cost: ${spaceShip.cost}'),
                      Consumer<PlayerData>(
                        builder: (context, playerData, child) {
                          final type =
                              SpaceShip.spaceShips.entries.elementAt(index).key;
                          final isEquipped = playerData.isEquipped(type);
                          final isOwned = playerData.isOwned(type);
                          final canBuy = playerData.canBuy(type);

                          return ElevatedButton(
                            onPressed: isEquipped
                                ? null
                                : () {
                                    if (isOwned) {
                                      playerData.equip(type);
                                    } else {
                                      if (canBuy) {
                                        playerData.buy(type);
                                      } else {
                                        // Displays an alert if player
                                        // does not have enough money.
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.red,
                                              title: const Text(
                                                'Insufficient Balance',
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Text(
                                                'Need ${spaceShip.cost - playerData.money} more',
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                            child: Text(
                              isEquipped
                                  ? 'Equipped'
                                  : isOwned
                                      ? 'Select'
                                      : 'Buy',
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GamePlay(),
                    ),
                  );
                },
                child: const Text('Play'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainMenu(),
                    ),
                  );
                },
                child: const Icon(Icons.arrow_back_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
