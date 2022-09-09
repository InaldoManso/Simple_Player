library simple_player;

//Packages
import 'package:simple_player/presentation/simple_player_screen.dart';
import 'package:simple_player/model/simple_player_settings.dart';
import 'package:flutter/material.dart';
//Resources
export 'model/simple_path_type.dart';
export 'model/simple_player_settings.dart';

class SimplePlayer {
  static Widget network({SimplePlayerSettings? simplePlayerSettings}) {
    return SimplePlayerScrren(simplePlayerSettings: simplePlayerSettings!);
  }
}
