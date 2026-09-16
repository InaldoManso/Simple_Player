import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../aplication/simple_aplication.dart';
import '../aplication/simple_controller.dart';
import '../model/simple_player_settings.dart';
import 'simple_player_fullscreen.dart';
import 'widgets/simple_player_stage.dart';

/// The inline player: sizes the player box and hands the playback over to
/// [SimplePlayerStage].
class SimplePlayerScreen extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final SimplePlayerSettings simplePlayerSettings;
  final SimpleController simpleController;

  const SimplePlayerScreen({
    super.key,
    required this.simpleController,
    required this.simplePlayerSettings,
    required this.videoPlayerController,
  });

  @override
  State<SimplePlayerScreen> createState() => _SimplePlayerScreenState();
}

class _SimplePlayerScreenState extends State<SimplePlayerScreen> {
  final SimpleAplication simpleAplication = SimpleAplication();

  /// Opens the full screen route, then restores the system UI and the
  /// orientation lock once the user comes back.
  Future<void> _openFullScreen() async {
    /// Going full screen is a deliberate move, so the sound comes on by itself
    /// and stays on after coming back.
    if (widget.videoPlayerController.value.volume == 0) {
      await widget.videoPlayerController.setVolume(1);
    }

    final double ratio = widget.videoPlayerController.value.aspectRatio;
    await simpleAplication.lockAndUnlockScreen(lock: true, aspectRatio: ratio);
    await simpleAplication.hideNavigation(true);

    /// Gives the system UI one beat to settle before the route transition.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SimplePlayerFullScreen(
          videoPlayerController: widget.videoPlayerController,
          simplePlayerSettings: widget.simplePlayerSettings,
          simpleController: widget.simpleController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SimplePlayerSettings settings = widget.simplePlayerSettings;

    final Widget stage = SimplePlayerStage(
      videoPlayerController: widget.videoPlayerController,
      simplePlayerSettings: settings,
      simpleController: widget.simpleController,
      fit: settings.fit,
      isFullScreen: false,
      onFullScreenPressed: _openFullScreen,
    );

    /// `expand: true` lets the player follow whatever box the parent gives it,
    /// otherwise the player box keeps its own [aspectRatio].
    if (settings.expand) return stage;
    return AspectRatio(aspectRatio: settings.aspectRatio, child: stage);
  }
}
