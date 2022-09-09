import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';

class SimpleAplication {
  String example =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  VideoPlayerController getControler(
      SimplePlayerSettings simplePlayerSettings) {
    switch (simplePlayerSettings.simplePathType.type) {
      case 'network':
        return VideoPlayerController.network(
            simplePlayerSettings.simplePathType.path!);

      case 'assets':
        return VideoPlayerController.asset(
            simplePlayerSettings.simplePathType.path!);

      default:
        return VideoPlayerController.network(example);
    }
  }
}
