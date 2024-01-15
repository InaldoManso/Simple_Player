import 'package:flutter/material.dart';

class Constants {
  static const String videoExample =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  SliderThemeData getSliderThemeData({Color? colorAccent}) {
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
