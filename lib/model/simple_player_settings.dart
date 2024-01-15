import 'package:flutter/material.dart';

class SimplePlayerSettings {
  String type;
  String path;
  String label;
  double aspectRatio;
  bool autoPlay;
  bool loopMode;
  bool forceAspectRatio;
  Color colorAccent;

  SimplePlayerSettings({
    required this.type,
    required this.path,
    required this.label,
    required this.aspectRatio,
    required this.autoPlay,
    required this.loopMode,
    required this.forceAspectRatio,
    required this.colorAccent,
  });

  ///
  /// ## SimplePlayerSettings properties can be configured in the following ways:
  ///
  /// ### String? path;
  /// Defines the origin of the file, which can be:
  /// SimplePlayerSettings.network (Video URL)
  /// SimplePlayerSettings.assets (Path of a video file)
  ///
  /// ### String? label;
  /// Sets the title displayed at the top dropdown of the video.
  ///
  /// ### double? aspectRatio; (default 16:9)
  /// Sets SimplePlayer's aspect ratio, this can let black embroideries on the video without distorting the image.
  ///
  /// ### bool? forceAspectRatio
  /// True case: Forces the video to fit the Player's aspect ratio, this may distort the image.
  /// #### Examples:
  /// - aspectRatio: 1 / 1,
  /// - forceAspectRatio: false
  ///
  /// ![bee](https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/bee_ratio_false.png)
  ///
  /// - aspectRatio: 1 / 1,
  /// - forceAspectRatio: true
  ///
  /// ![bee](https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/bee_ratio_true.png)
  ///
  /// ### bool? autoPlay;
  /// If true: as soon as the Player is built the video will be played automatically.
  ///
  /// ### bool? loopMode;
  /// If true: As soon as the video finishes playing, it will restart automatically.
  ///
  /// ### Color? colorAccent;
  /// Sets the SimplePlayer details color.
  ///

  factory SimplePlayerSettings.network(
      {required String path,
      String? label,
      double? aspectRatio,
      bool? autoPlay,
      bool? loopMode,
      bool? forceAspectRatio,
      Color? colorAccent}) {
    return SimplePlayerSettings(
        type: 'network',
        path: path,
        label: label ?? '',
        aspectRatio: aspectRatio ?? 16 / 9,
        autoPlay: autoPlay ?? false,
        loopMode: loopMode ?? false,
        forceAspectRatio: forceAspectRatio ?? false,
        colorAccent: colorAccent ?? Colors.red);
  }

  factory SimplePlayerSettings.assets(
      {required String path,
      String? label,
      double? aspectRatio,
      bool? autoPlay,
      bool? loopMode,
      bool? forceAspectRatio,
      Color? colorAccent}) {
    return SimplePlayerSettings(
        type: 'assets',
        path: path,
        label: label ?? '',
        aspectRatio: aspectRatio ?? 16 / 9,
        autoPlay: autoPlay ?? false,
        loopMode: loopMode ?? false,
        forceAspectRatio: forceAspectRatio ?? false,
        colorAccent: colorAccent ?? Colors.red);
  }
}
