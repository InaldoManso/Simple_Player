import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

/// Minimal in-memory implementation of [VideoPlayerPlatform] so the widget
/// tests can drive a real [VideoPlayerController] without a native player.
class FakeVideoPlayerPlatform extends VideoPlayerPlatform
    with MockPlatformInterfaceMixin {
  FakeVideoPlayerPlatform({
    this.size = const Size(1920, 1080),
    this.duration = const Duration(seconds: 10),
  });

  final Size size;
  final Duration duration;

  int _nextPlayerId = 0;
  final Map<int, StreamController<VideoEvent>> _events =
      <int, StreamController<VideoEvent>>{};

  static void register({
    Size size = const Size(1920, 1080),
    Duration duration = const Duration(seconds: 10),
  }) {
    VideoPlayerPlatform.instance =
        FakeVideoPlayerPlatform(size: size, duration: duration);
  }

  @override
  Future<void> init() async {}

  @override
  Future<int?> create(DataSource dataSource) => _create();

  @override
  Future<int?> createWithOptions(VideoCreationOptions options) => _create();

  Future<int> _create() async {
    final int playerId = _nextPlayerId++;
    /// Single-subscription so the `initialized` event is buffered until
    /// VideoPlayerController actually subscribes to the stream.
    final controller = StreamController<VideoEvent>();
    _events[playerId] = controller;

    /// The controller only completes `initialize()` once this event lands.
    scheduleMicrotask(() {
      controller.add(
        VideoEvent(
          eventType: VideoEventType.initialized,
          duration: duration,
          size: size,
          rotationCorrection: 0,
        ),
      );
    });

    return playerId;
  }

  @override
  Stream<VideoEvent> videoEventsFor(int playerId) =>
      _events[playerId]!.stream;

  @override
  Future<void> dispose(int playerId) async {
    await _events.remove(playerId)?.close();
  }

  @override
  Future<void> setLooping(int playerId, bool looping) async {}

  @override
  Future<void> play(int playerId) async {}

  @override
  Future<void> pause(int playerId) async {}

  @override
  Future<void> setVolume(int playerId, double volume) async {}

  @override
  Future<void> seekTo(int playerId, Duration position) async {}

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async {}

  @override
  Future<Duration> getPosition(int playerId) async => Duration.zero;

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) async {}

  @override
  Widget buildView(int playerId) => const ColoredBox(color: Colors.blue);

  @override
  Widget buildViewWithOptions(VideoViewOptions options) =>
      const ColoredBox(color: Colors.blue);
}
