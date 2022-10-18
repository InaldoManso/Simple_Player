import 'package:simple_player/model/simple_path_type.dart';
import 'package:flutter/material.dart';

class SimplePlayerSettings {
  SimplePathType simplePathType;
  String? label = '';
  double? aspectRatio = 16 / 9;
  bool? autoPlay = false;
  bool? loopMode = false;
  Color? colorAccent = Colors.red;

  SimplePlayerSettings({
    required this.simplePathType,
    this.label = '',
    this.aspectRatio = 16 / 9,
    this.autoPlay = false,
    this.loopMode = false,
    this.colorAccent = Colors.red,
  });
}
