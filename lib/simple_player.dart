library simple_player;

/// Packages
import 'package:simple_player/aplication/simple_controller.dart';
import 'package:simple_player/constants/constants.dart';
import 'package:simple_player/presentation/simple_player_screen.dart';
import 'package:simple_player/model/simple_player_settings.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

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
  ///     forceAspectRatio: false,
  ///     colorAccent: Colors.red,
  ///   ),
  /// )
  /// ```
  ///
  /// {@tool snippet}
  ///
  ///The player should behave like this:
  ///
  /// ![bee](https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/player.png)
  ///
  ///Keep an eye out for examples. 🕶️
  ///Good coding! 😎💙
  ///
  const SimplePlayer({
    Key? key,
    required this.simpleController,
    required this.simplePlayerSettings,
  }) : super(key: key);

  @override
  State<SimplePlayer> createState() => _SimplePlayerState();
}

class _SimplePlayerState extends State<SimplePlayer> {
  // Attributes
  late VideoPlayerController videoPlayerController;
  bool loaded = false;

  /// The function `getControler` initializes a video player controller based on the type of video
  /// specified in the `simplePlayerSettings` parameter.
  ///
  /// Args:
  ///   simplePlayerSettings (SimplePlayerSettings): The `simplePlayerSettings` parameter is an object of
  /// type `SimplePlayerSettings`. It contains information about the type of video player and the path to
  /// the video file.
  getControler(SimplePlayerSettings simplePlayerSettings) async {
    switch (simplePlayerSettings.type) {
      case 'network':
        videoPlayerController = VideoPlayerController.networkUrl(
            Uri.parse(simplePlayerSettings.path));
        break;

      case 'assets':
        videoPlayerController =
            VideoPlayerController.asset(simplePlayerSettings.path);
        break;

      default:
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(Constants.videoExample));
        break;
    }

    // Ready to play
    await videoPlayerController.initialize();
    setState(() => loaded = true);
  }

  @override
  void initState() {
    getControler(widget.simplePlayerSettings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return SimplePlayerScrren(
        videoPlayerController: videoPlayerController,
        simpleController: widget.simpleController,
        simplePlayerSettings: widget.simplePlayerSettings,
      );
    } else {
      return AspectRatio(
        aspectRatio: widget.simplePlayerSettings.aspectRatio,
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: widget.simplePlayerSettings.colorAccent,
          ),
        ),
      );
    }
  }
}
