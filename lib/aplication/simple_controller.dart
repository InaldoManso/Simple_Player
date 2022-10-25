import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class SimpleController extends ChangeNotifier {
  late VideoPlayerController videoPlayerController;
  late Duration position;

  SimpleController();

  void play() {
    videoPlayerController.play();
    notifyListeners();
  }

  void pause() {
    videoPlayerController.pause();
    notifyListeners();
  }

  ///⛔ This method should not be called unless you know what it is doing. ☢️
  void updateController(VideoPlayerController controller) {
    videoPlayerController = controller;
    _setPosition(controller.value.position);
    notifyListeners();
  }

  void _setPosition(Duration value) {
    position = value;
    print(position);
    notifyListeners();
  }
}
