library simple_player;

import 'package:simple_player/presentation/simple_player_network_screen.dart';
import 'package:simple_player/model/simple_player_settings.dart';
export 'model/simple_player_settings.dart';
import 'package:flutter/material.dart';

class SimplePlayer {
  static Widget network({SimplePlayerSettings? simplePlayerSettings}) {
    return SimplePlayerNetworkScrren(
        simplePlayerSettings: simplePlayerSettings!);
  }
}
