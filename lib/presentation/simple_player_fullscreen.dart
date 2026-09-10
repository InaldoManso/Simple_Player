import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../aplication/simple_aplication.dart';
import '../aplication/simple_controller.dart';
import '../model/simple_player_settings.dart';
import 'widgets/simple_player_stage.dart';

/// The full screen route. Same stage as the inline player, scaled with
/// [SimplePlayerSettings.fullScreenFit].
class SimplePlayerFullScreen extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final SimplePlayerSettings simplePlayerSettings;
  final SimpleController simpleController;

  const SimplePlayerFullScreen({
    super.key,
    required this.videoPlayerController,
    required this.simplePlayerSettings,
    required this.simpleController,
  });

  @override
  State<SimplePlayerFullScreen> createState() => _SimplePlayerFullScreenState();
}

class _SimplePlayerFullScreenState extends State<SimplePlayerFullScreen> {
  final SimpleAplication simpleAplication = SimpleAplication();

  /// Restores the system bars and the free rotation before leaving.
  Future<void> _exitFullScreen() async {
    await simpleAplication.hideNavigation(false);
    await simpleAplication.lockAndUnlockScreen(lock: false);
    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        _exitFullScreen();
      },
      child: Material(
        color: Colors.black,
        child: SimplePlayerStage(
          videoPlayerController: widget.videoPlayerController,
          simplePlayerSettings: widget.simplePlayerSettings,
          simpleController: widget.simpleController,
          fit: widget.simplePlayerSettings.fullScreenFit,
          isFullScreen: true,
          onFullScreenPressed: _exitFullScreen,
        ),
      ),
    );
  }
}
