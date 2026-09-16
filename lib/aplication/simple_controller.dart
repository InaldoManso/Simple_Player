import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SimpleController extends ChangeNotifier {
  late VideoPlayerController videoPlayerController;
  Duration position = Duration.zero;

  /// Event driven streams.
  ///
  /// They replace the old 50ms polling loops, which kept a timer alive for the
  /// whole lifetime of the app even after the player had been disposed.
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<String> _playPauseController =
      StreamController<String>.broadcast();

  SimpleController();

  /// ## ▶️ Start playing the video
  void play() {
    videoPlayerController.play();
    _emitPlayPause();
    notifyListeners();
  }

  /// ## ⏸️ Pause video playback
  void pause() {
    videoPlayerController.pause();
    _emitPlayPause();
    notifyListeners();
  }

  /// ## ⏩ Change the playback speed (1.0 is the normal rate)
  Future<void> setSpeed(double speed) async {
    await videoPlayerController.setPlaybackSpeed(speed);
    notifyListeners();
  }

  /// ## 🔊 Change the volume (0.0 is silent, 1.0 is full)
  Future<void> setVolume(double volume) async {
    await videoPlayerController.setVolume(volume);
    notifyListeners();
  }

  /// ## ⏱️ Jump to a given point of the video
  Future<void> seekTo(Duration position) async {
    await videoPlayerController.seekTo(position);
    notifyListeners();
  }

  /// ## ⛔ By disposing of the controller <br>
  /// ⚠️ This method does not need to be called in normal cases, SimplePlayer already has an AutoDispose to facilitate its correct use.
  void delete() {
    videoPlayerController.dispose();
    notifyListeners();
  }

  /// 📽️ Returning a stream of the current position of the video.
  Stream<Duration> listenPosition() => _positionController.stream;

  ///⏯️ Returning a current play and pause stream of the video.
  Stream<String> listenPlayAndPause() => _playPauseController.stream;

  ///⛔ This method should not be called unless you know what it is doing. ☢️
  void updateController(VideoPlayerController controller) {
    videoPlayerController = controller;
    _setPosition(controller.value.position);
    notifyListeners();
  }

  void _setPosition(Duration value) {
    if (position == value) return;
    position = value;
    if (!_positionController.isClosed) _positionController.add(value);
    notifyListeners();
  }

  void _emitPlayPause() {
    if (_playPauseController.isClosed) return;
    _playPauseController.add(DateTime.now().toIso8601String());
  }

  @override
  void dispose() {
    _positionController.close();
    _playPauseController.close();
    super.dispose();
  }
}
