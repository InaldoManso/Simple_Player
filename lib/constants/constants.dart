import 'package:flutter/material.dart';

class Constants {
  static const String videoExample =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  /// The function returns a SliderThemeData object with customizable properties for a slider widget in
  /// Dart.
  ///
  /// Args:
  ///   colorAccent (Color): The `colorAccent` parameter is an optional parameter that allows you to
  /// specify a custom accent color for the slider. If no value is provided for `colorAccent`, the default
  /// accent color will be set to `Colors.red`.
  ///
  /// Returns:
  ///   a SliderThemeData object.
  static SliderThemeData getSliderThemeData({Color? colorAccent}) {
    Color accentColor = colorAccent ?? Colors.red;
    return SliderThemeData(
      activeTrackColor: accentColor,
      thumbColor: Colors.white,
      inactiveTrackColor: Colors.grey,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      overlayColor: accentColor.withOpacity(0.5),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
      activeTickMarkColor: Colors.white,
      inactiveTickMarkColor: Colors.white,
    );
  }
}
