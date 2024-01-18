import 'package:flutter/services.dart';

class SimpleAplication {
  /// The function `doubleConvert` takes a double value representing a volume and returns a string
  /// representation of the volume as a percentage.
  ///
  /// Args:
  ///   volume (double): The volume parameter is a double value representing a volume measurement.
  ///
  /// Returns:
  ///   a string representation of the input volume as a percentage. If the volume is equal to 0.05, it
  /// returns '5%'. If the volume is equal to 1.0, it returns '100%'. For any other volume value, it
  /// converts the volume to a string with two decimal places using `toStringAsPrecision(2)`, removes the
  /// decimal point using `
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

  /// The function speedConvert converts a double value to a string with two decimal places and appends
  /// "x" at the end.
  ///
  /// Args:
  ///   volume (double): The volume parameter is a double value representing the speed that needs to be
  /// converted.
  ///
  /// Returns:
  ///   a string representation of the input volume, rounded to 2 decimal places, followed by the letter
  /// 'x'.
  String speedConvert(double volume) {
    String value = volume.toStringAsPrecision(2);
    return '$value x';
  }

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
