import 'package:flutter/foundation.dart';

import '../models/player_model.dart';

class PlayerProvider extends ChangeNotifier {
  late Player playerData = Player(color: 'playerShip1_orange.png');

  Player getPlayerData(String color) {

    playerData = Player(color: color);
    
    return playerData;
  }
}
