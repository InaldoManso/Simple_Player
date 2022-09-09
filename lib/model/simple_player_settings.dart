import 'package:simple_player/model/simple_path_type.dart';

class SimplePlayerSettings {
  SimplePathType simplePathType;
  String? label = '';
  double? aspectRatio = 16 / 9;
  bool? autoPlay = false;

  SimplePlayerSettings({
    required this.simplePathType,
    this.label = '',
    this.aspectRatio = 16 / 9,
    this.autoPlay = false,
  });
}
