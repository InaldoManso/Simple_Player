import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_player/simple_player.dart';

void main() {
  group('SimplePlayerSettings fit resolution', () {
    test('defaults to BoxFit.contain on both modes', () {
      final settings = SimplePlayerSettings.network(path: 'https://a/b.mp4');

      expect(settings.fit, BoxFit.contain);
      expect(settings.fullScreenFit, BoxFit.contain);
      expect(settings.expand, isFalse);
      expect(settings.aspectRatio, 16 / 9);
    });

    test('keeps fit and fullScreenFit independent', () {
      final settings = SimplePlayerSettings.assets(
        path: 'assets/b.mp4',
        fit: BoxFit.cover,
        fullScreenFit: BoxFit.contain,
      );

      expect(settings.fit, BoxFit.cover);
      expect(settings.fullScreenFit, BoxFit.contain);
    });

  });
}
