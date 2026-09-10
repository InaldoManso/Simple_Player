library;

/// Packages
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:simple_player/aplication/simple_controller.dart';
import 'package:simple_player/constants/constants.dart';
import 'package:simple_player/model/simple_player_settings.dart';
import 'package:simple_player/presentation/simple_player_screen.dart';

/// Resources
export 'aplication/simple_controller.dart';
export 'model/simple_player_settings.dart';

class SimplePlayer extends StatefulWidget {
  final SimplePlayerSettings simplePlayerSettings;
  final SimpleController simpleController;

  ///A Simple and ready to use Player!
  ///
  ///Make sure:
  ///- always call the extension:
  ///  SimplePlayerSettings.network() or SimplePlayerSettings.assets()
  ///- perform the import do: import 'package:flutter/material.dart';
  ///
  ///To ensure a good functioning of the Package.
  ///
  ///
  /// ```dart
  ///
  /// //exmaple:
  ///
  /// SimpleController simpleController = SimpleController();
  /// String url = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
  ///
  /// SimplePlayer(
  ///   simpleController: simpleController,
  ///   simplePlayerSettings: SimplePlayerSettings.network(
  ///     path: url,
  ///     label: 'Bee',
  ///     aspectRatio: 16 / 9,
  ///     autoPlay: false,
  ///     loopMode: true,
  ///     fit: BoxFit.cover,
  ///     fullScreenFit: BoxFit.contain,
  ///     colorAccent: Colors.red,
  ///   ),
  /// )
  /// ```
  ///
  ///
  ///The player should behave like this:
  ///
  /// ![SimplePlayer](https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/player_inline.jpg)
  ///
  ///Keep an eye out for examples. 🕶️
  ///Good coding! 😎💙
  ///
  const SimplePlayer({
    super.key,
    required this.simpleController,
    required this.simplePlayerSettings,
  });

  @override
  State<SimplePlayer> createState() => _SimplePlayerState();
}

class _SimplePlayerState extends State<SimplePlayer> {
  // Attributes
  VideoPlayerController? videoPlayerController;
  bool loaded = false;
  Object? error;

  /// Builds the [VideoPlayerController] that matches the configured source and
  /// waits for it to be ready to play.
  Future<void> getControler(SimplePlayerSettings simplePlayerSettings) async {
    final VideoPlayerController controller;

    switch (simplePlayerSettings.type) {
      case 'assets':
        controller = VideoPlayerController.asset(simplePlayerSettings.path);
      case 'network':
        controller = VideoPlayerController.networkUrl(
          Uri.parse(simplePlayerSettings.path),
        );
      default:
        controller = VideoPlayerController.networkUrl(
          Uri.parse(Constants.videoExample),
        );
    }

    videoPlayerController = controller;

    // Ready to play
    try {
      await controller.initialize();
    } catch (exception) {
      // A dead URL, a missing asset or an unavailable platform implementation
      // must not blow up the host app nor spin forever.
      debugPrint('SimplePlayer could not open "${simplePlayerSettings.path}": '
          '$exception');
      if (!mounted) return;
      setState(() => error = exception);
      return;
    }

    if (!mounted) return;

    /// Publish the controller before the first frame so the public
    /// SimpleController API is usable as soon as the player is up.
    widget.simpleController.updateController(controller);

    /// Playback options are applied once, here, so entering full screen does
    /// not retrigger autoPlay.
    await controller.setLooping(simplePlayerSettings.loopMode);
    if (simplePlayerSettings.autoPlay) await controller.play();

    if (!mounted) return;
    setState(() => loaded = true);
  }

  @override
  void initState() {
    super.initState();
    getControler(widget.simplePlayerSettings);
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SimplePlayerSettings settings = widget.simplePlayerSettings;

    if (loaded && videoPlayerController != null) {
      return SimplePlayerScreen(
        videoPlayerController: videoPlayerController!,
        simpleController: widget.simpleController,
        simplePlayerSettings: settings,
      );
    }

    final Widget placeholder = ColoredBox(
      color: Colors.black,
      child: Center(
        child: error != null
            ? Icon(Icons.videocam_off_outlined, color: settings.colorAccent)
            : CircularProgressIndicator(color: settings.colorAccent),
      ),
    );

    /// The placeholder must reserve exactly the same box the loaded player
    /// will take, so the layout does not jump once the first frame arrives.
    if (settings.expand) return placeholder;
    return AspectRatio(aspectRatio: settings.aspectRatio, child: placeholder);
  }
}
