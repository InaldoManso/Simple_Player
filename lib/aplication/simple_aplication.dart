import 'package:flutter/services.dart';
import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';

class SimpleAplication {
  String example =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  VideoPlayerController getControler(
      SimplePlayerSettings simplePlayerSettings) {
    switch (simplePlayerSettings.type) {
      case 'network':
        return VideoPlayerController.network(simplePlayerSettings.path!);
      case 'assets':
        return VideoPlayerController.asset(simplePlayerSettings.path!);
      default:
        return VideoPlayerController.network(example);
    }
  }

  String doubleConvert(double volume) {
    if (volume == 0.05) {
      return '5%';
    } else if (volume == 1.0) {
      return '100%';
    } else {
      int value = int.parse(volume.toStringAsPrecision(2).replaceAll('.', ''));
      return '$value%';
    }
  }

  String speedConvert(double volume) {
    String value = volume.toStringAsPrecision(2);
    return '$value x';
  }

  Future<bool> hideNavigation(bool hide) async {
    if (hide) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)
          .whenComplete(() {});
      return true;
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      return false;
    }
  }

  Future<bool> lockAndUnlockScreen(
      {required bool lock, double aspectRatio = 1.0}) async {
    if (lock) {
      if (aspectRatio <= 1.0) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      } else {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        return true;
      }
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      return true;
    }
  }
}
