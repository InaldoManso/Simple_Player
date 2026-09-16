import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../aplication/simple_controller.dart';
import '../../model/simple_player_settings.dart';
import 'simple_player_controls.dart';
import 'simple_video_surface.dart';

/// The playable surface: video layer + interface layer.
///
/// Both the inline player and the full screen route render this same widget,
/// changing only [fit], [isFullScreen] and what the full screen button does.
class SimplePlayerStage extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final SimplePlayerSettings simplePlayerSettings;
  final SimpleController simpleController;
  final BoxFit fit;
  final bool isFullScreen;
  final VoidCallback onFullScreenPressed;

  const SimplePlayerStage({
    super.key,
    required this.videoPlayerController,
    required this.simplePlayerSettings,
    required this.simpleController,
    required this.fit,
    required this.isFullScreen,
    required this.onFullScreenPressed,
  });

  @override
  State<SimplePlayerStage> createState() => _SimplePlayerStageState();
}

class _SimplePlayerStageState extends State<SimplePlayerStage>
    with SingleTickerProviderStateMixin {
  /// How long the interface stays up after the last interaction.
  static const Duration _autoHideDelay = Duration(seconds: 3);

  late final AnimationController _playPauseController;
  StreamSubscription<String>? _externalPlayPause;
  Timer? _hideTimer;

  bool _visible = true;
  bool _scrubbing = false;
  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _isMuted = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Duration _buffered = Duration.zero;

  VideoPlayerController get _controller => widget.videoPlayerController;

  @override
  void initState() {
    super.initState();

    _isPlaying = _controller.value.isPlaying;
    _isMuted = _controller.value.volume == 0;
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      /// Entering full screen mid playback must not replay the icon animation.
      value: _isPlaying ? 1 : 0,
    );

    _readValue();
    _controller.addListener(_onVideoValueChanged);
    _listenExternalController();

    if (_isPlaying) _scheduleHide();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _externalPlayPause?.cancel();
    _controller.removeListener(_onVideoValueChanged);
    _playPauseController.dispose();
    super.dispose();
  }

  /// Mirrors play/pause issued through the public [SimpleController].
  void _listenExternalController() {
    _externalPlayPause =
        widget.simpleController.listenPlayAndPause().listen((_) {
      if (!mounted) return;
      _showControls();
    });
  }

  void _onVideoValueChanged() {
    if (!mounted) return;
    widget.simpleController.updateController(_controller);
    _readValue();
  }

  void _readValue() {
    final VideoPlayerValue value = _controller.value;
    final List<DurationRange> ranges = value.buffered;

    final bool wasPlaying = _isPlaying;
    final Duration buffered = ranges.isEmpty ? Duration.zero : ranges.last.end;

    if (mounted) {
      setState(() {
        _position = value.position;
        _duration = value.duration;
        _buffered = buffered;
        _isPlaying = value.isPlaying;
        _isBuffering = value.isBuffering;
        _isMuted = value.volume == 0;
      });
    }

    if (wasPlaying == value.isPlaying) return;

    /// Keep the animated icon and the auto hide in sync with playback started
    /// or stopped from anywhere — the HUD, the controller or the end of the
    /// video itself.
    if (value.isPlaying) {
      _playPauseController.forward();
      _scheduleHide();
    } else {
      _playPauseController.reverse();
      _showControls(autoHide: false);
    }
  }

  bool get _ended =>
      _duration > Duration.zero && _position >= _duration && !_isPlaying;

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _controller.pause();
      return;
    }

    /// Restart instead of sitting on the last frame.
    if (_ended) await _controller.seekTo(Duration.zero);
    await _controller.play();
  }

  /// The badge is a one way switch: it only exists to turn the sound back on.
  Future<void> _unmute() async {
    await _controller.setVolume(1);
  }

  void _onTap() {
    if (_visible) {
      _hide();
    } else {
      _showControls();
    }
  }

  void _showControls({bool autoHide = true}) {
    _hideTimer?.cancel();
    if (!_visible) setState(() => _visible = true);
    if (autoHide) _scheduleHide();
  }

  void _hide() {
    _hideTimer?.cancel();
    if (_visible) setState(() => _visible = false);
  }

  /// The interface only fades away while the video is actually running and the
  /// user is not dragging the seek bar.
  void _scheduleHide() {
    _hideTimer?.cancel();
    if (!_isPlaying || _scrubbing) return;
    _hideTimer = Timer(_autoHideDelay, () {
      if (mounted) _hide();
    });
  }

  void _onScrubbing(bool scrubbing) {
    _scrubbing = scrubbing;
    scrubbing ? _hideTimer?.cancel() : _scheduleHide();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// Layer 1 — the video frame only. `fit` is applied (and clipped)
          /// inside this subtree, so it can never reach the layer above.
          SimpleVideoSurface(controller: _controller, fit: widget.fit),

          /// Layer 2 — the interface. Always receives the full player box.
          SimplePlayerControls(
            title: widget.simplePlayerSettings.label,
            colorAccent: widget.simplePlayerSettings.colorAccent,
            visible: _visible,
            isFullScreen: widget.isFullScreen,
            isBuffering: _isBuffering,
            position: _position,
            duration: _duration,
            buffered: _buffered,
            playPauseProgress: _playPauseController,

            /// Full screen turns the sound on by itself, so the badge belongs
            /// to the inline player only.
            showMuteBadge: !widget.isFullScreen && _isMuted,
            onUnmute: _unmute,
            onTap: _onTap,
            onPlayPause: _togglePlayPause,
            onFullScreen: widget.onFullScreenPressed,
            onSeek: _controller.seekTo,
            onScrubbing: _onScrubbing,
          ),
        ],
      ),
    );
  }
}
