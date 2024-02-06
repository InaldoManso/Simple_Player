import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SimpleController extends ChangeNotifier {
  late VideoPlayerController videoPlayerController;
  late Duration position = const Duration().abs();
  String _changePlay = '';

  SimpleController();

  /// ## ▶️ Start playing the video
  void play() {
    _changePlay = DateTime.now().toString();
    videoPlayerController.play();
    notifyListeners();
  }

  /// ## ⏸️ Pause video playback
  void pause() {
    _changePlay = DateTime.now().toString();
    videoPlayerController.pause();
    notifyListeners();
  }

  /// ## ⛔ By disposing of the controller <br>
  /// ⚠️ This method does not need to be called in normal cases, SimplePlayer already has an AutoDispose to facilitate its correct use.
  void delete() {
    videoPlayerController.dispose();
    notifyListeners();
  }

  /// 📽️ Returning a stream of the current position of the video.
  Stream<Duration> listenPosition() async* {
    while (true) {
      yield position;
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  ///⏯️ Returning a current play and pause stream of the video.
  Stream<String> listenPlayAndPause() async* {
    while (true) {
      yield _changePlay;
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  ///⛔ This method should not be called unless you know what it is doing. ☢️
  void updateController(VideoPlayerController controller) {
    videoPlayerController = controller;
    _setPosition(controller.value.position);
    notifyListeners();
  }

  void _setPosition(Duration value) {
    position = value;
    notifyListeners();
  }
}
