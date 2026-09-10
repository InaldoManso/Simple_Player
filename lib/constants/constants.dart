import 'package:flutter/material.dart';

class Constants {
  static const String videoExample =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  /// Slim seek bar, in line with what current video players look like:
  /// a thin track, a small thumb and a lighter band for the buffered range.
  static SliderThemeData timelineTheme(Color colorAccent) {
    return SliderThemeData(
      trackHeight: 3,
      activeTrackColor: colorAccent,
      inactiveTrackColor: Colors.white24,
      secondaryActiveTrackColor: Colors.white38,
      thumbColor: colorAccent,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 6,
        pressedElevation: 0,
        elevation: 0,
      ),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
      overlayColor: colorAccent.withValues(alpha: 0.25),
      trackShape: const RoundedRectSliderTrackShape(),
      showValueIndicator: ShowValueIndicator.never,
    );
  }
}
