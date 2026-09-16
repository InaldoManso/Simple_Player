import 'package:flutter/material.dart';

/// Holds every visual/behavioural option of a [SimplePlayer] instance.
///
/// Prefer the [SimplePlayerSettings.network] / [SimplePlayerSettings.assets]
/// factories over the raw constructor.
class SimplePlayerSettings {
  final String type;
  final String path;
  final String label;
  final double aspectRatio;
  final bool autoPlay;
  final bool loopMode;
  final bool expand;

  /// Starts the video silent when [autoPlay] kicks in.
  ///
  /// While the sound is off the inline player shows a small muted badge the
  /// viewer can tap to turn it on. Going full screen turns it on as well.
  final bool muteOnAutoPlay;
  final Color colorAccent;

  /// How the video frame is scaled inside the player box (inline mode).
  final BoxFit fit;

  /// How the video frame is scaled inside the player box (full screen mode).
  final BoxFit fullScreenFit;

  const SimplePlayerSettings({
    required this.type,
    required this.path,
    required this.label,
    required this.aspectRatio,
    required this.autoPlay,
    required this.loopMode,
    required this.colorAccent,
    this.fit = BoxFit.contain,
    this.fullScreenFit = BoxFit.contain,
    this.expand = false,
    this.muteOnAutoPlay = false,
  });

  ///
  /// ## SimplePlayerSettings
  /// ### Properties can be configured in the following ways:
  ///
  /// ### String path;
  /// Defines the origin of the file, which can be:
  /// SimplePlayerSettings.network (Video URL)
  /// SimplePlayerSettings.assets (Path of a video file)
  ///
  /// ### String? label;
  /// Sets the title displayed at the top of the video.
  ///
  /// ### double? aspectRatio; (default 16:9)
  /// Sets the aspect ratio of the **player box** — the area the widget occupies
  /// on your layout. Ignored when `expand: true`.
  ///
  /// ### bool? expand; (default false)
  /// If true the player fills whatever box its parent gives it instead of
  /// forcing [aspectRatio]. Useful to let the player follow a container that
  /// has a proportion of its own.
  ///
  /// ### BoxFit? fit; (default BoxFit.contain)
  /// Decides how the video frame is scaled inside the player box:
  /// - [BoxFit.contain]: the whole video is visible, black bars may appear.
  /// - [BoxFit.cover]: the box is fully painted, the video is cropped.
  /// - [BoxFit.fill]: the video is stretched to the box (distorts the image).
  ///
  /// The player controls (play/pause, timeline, full screen button) live on a
  /// separate layer and are **never** clipped or distorted by this option.
  ///
  /// ### BoxFit? fullScreenFit; (default BoxFit.contain)
  /// Same as [fit], but applied while the player is in full screen. This lets
  /// you use, for instance, `fit: BoxFit.cover` on a feed and
  /// `fullScreenFit: BoxFit.contain` once the video is opened.
  ///
  /// ### bool? autoPlay;
  /// If true: as soon as the Player is built the video will be played automatically.
  ///
  /// ### bool? muteOnAutoPlay; (default false)
  /// If true the video starts silent when [autoPlay] is on — the usual way a
  /// video behaves inside a feed. A small muted badge is then shown on the
  /// inline player, and tapping it turns the sound on. Opening full screen
  /// turns the sound on too, so the badge never shows up there.
  ///
  /// ### bool? loopMode;
  /// If true: As soon as the video finishes playing, it will restart automatically.
  ///
  /// ### Color? colorAccent;
  /// Sets the SimplePlayer details color.
  ///
  factory SimplePlayerSettings.network({
    required String path,
    String? label,
    double? aspectRatio,
    bool? autoPlay,
    bool? loopMode,
    bool? expand,
    bool? muteOnAutoPlay,
    BoxFit? fit,
    BoxFit? fullScreenFit,
    Color? colorAccent,
  }) {
    return SimplePlayerSettings(
      type: 'network',
      path: path,
      label: label ?? '',
      aspectRatio: aspectRatio ?? 16 / 9,
      autoPlay: autoPlay ?? false,
      loopMode: loopMode ?? false,
      expand: expand ?? false,
      muteOnAutoPlay: muteOnAutoPlay ?? false,
      fit: fit ?? BoxFit.contain,
      fullScreenFit: fullScreenFit ?? BoxFit.contain,
      colorAccent: colorAccent ?? Colors.red,
    );
  }

  /// See [SimplePlayerSettings.network] for the full property reference.
  factory SimplePlayerSettings.assets({
    required String path,
    String? label,
    double? aspectRatio,
    bool? autoPlay,
    bool? loopMode,
    bool? expand,
    bool? muteOnAutoPlay,
    BoxFit? fit,
    BoxFit? fullScreenFit,
    Color? colorAccent,
  }) {
    return SimplePlayerSettings(
      type: 'assets',
      path: path,
      label: label ?? '',
      aspectRatio: aspectRatio ?? 16 / 9,
      autoPlay: autoPlay ?? false,
      loopMode: loopMode ?? false,
      expand: expand ?? false,
      muteOnAutoPlay: muteOnAutoPlay ?? false,
      fit: fit ?? BoxFit.contain,
      fullScreenFit: fullScreenFit ?? BoxFit.contain,
      colorAccent: colorAccent ?? Colors.red,
    );
  }
}
