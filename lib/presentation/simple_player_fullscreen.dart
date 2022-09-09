import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_player/model/simple_player_settings.dart';
import 'package:simple_player/model/simple_player_state.dart';

class SimplePlayerFullScreen extends StatefulWidget {
  final SimplePlayerSettings simplePlayerSettings;
  final SimplePlayerState simplePlayerState;
  const SimplePlayerFullScreen(
      {Key? key,
      required this.simplePlayerSettings,
      required this.simplePlayerState})
      : super(key: key);

  @override
  State<SimplePlayerFullScreen> createState() => _SimplePlayerFullScreenState();
}

class _SimplePlayerFullScreenState extends State<SimplePlayerFullScreen> {
  _hideNavigation(bool hide) {
    if (hide) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    }
  }

  _lockAndUnlockScreen(bool lock) {
    if (lock) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  void initState() {
    _lockAndUnlockScreen(true);
    _hideNavigation(true);
    super.initState();
  }

  @override
  void dispose() {
    _lockAndUnlockScreen(false);
    _hideNavigation(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Full Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
