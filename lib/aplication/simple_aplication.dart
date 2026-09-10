import 'package:flutter/services.dart';

class SimpleAplication {
  /// The function `hideNavigation` in Dart is used to hide or show the system navigation bar.
  ///
  /// Args:
  ///   hide (bool): The `hide` parameter is a boolean value that determines whether to hide or show the
  /// navigation bar. If `hide` is `true`, the navigation bar will be hidden. If `hide` is `false`, the
  /// navigation bar will be shown.
  ///
  /// Returns:
  ///   a `Future<bool>`.
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

  /// The function `lockAndUnlockScreen` locks or unlocks the screen orientation based on the `lock`
  /// parameter and the `aspectRatio` value.
  ///
  /// Args:
  ///   lock (bool): A boolean value indicating whether to lock or unlock the screen orientation.
  ///   aspectRatio (double): The aspectRatio parameter is a double value that represents the aspect ratio
  /// of the screen. It is used to determine the preferred orientations when locking or unlocking the
  /// screen. If the aspect ratio is less than or equal to 1.0, the preferred orientations will be set to
  /// portrait mode. Otherwise, the. Defaults to 1.0
  ///
  /// Returns:
  ///   A boolean value is being returned.
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
