import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';

import 'fake_video_player_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    /// 16:9 source video, so every non-`contain` fit has something to crop.
    FakeVideoPlayerPlatform.register(size: const Size(1920, 1080));
  });

  /// Pumps the player inside a 300x300 viewport with the given settings and
  /// waits for the fake platform to report `initialized`.
  Future<void> pumpPlayer(WidgetTester tester, SimplePlayerSettings settings) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: SimplePlayer(
                simpleController: SimpleController(),
                simplePlayerSettings: settings,
              ),
            ),
          ),
        ),
      ),
    );

    /// `SimpleController` exposes endless polling streams, so the tree never
    /// goes quiet: pump explicit frames instead of `pumpAndSettle`.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('applies fit to the video layer only', (tester) async {
    await pumpPlayer(
      tester,
      SimplePlayerSettings.network(
        path: 'https://example.com/bee.mp4',
        aspectRatio: 1 / 1,
        fit: BoxFit.cover,
      ),
    );

    final FittedBox fittedBox = tester.widget<FittedBox>(find.byType(FittedBox));
    expect(fittedBox.fit, BoxFit.cover);

    /// The overflow of `cover` must be clipped inside the video layer.
    expect(fittedBox.clipBehavior, Clip.hardEdge);
  });

  testWidgets('controls are never clipped by the video fit', (tester) async {
    await pumpPlayer(
      tester,
      SimplePlayerSettings.network(
        path: 'https://example.com/bee.mp4',
        aspectRatio: 1 / 1,
        fit: BoxFit.cover,
      ),
    );

    /// The player box: a 1:1 square inside the 300x300 viewport.
    final Rect playerRect = tester.getRect(find.byType(SimplePlayer));
    expect(playerRect.size, const Size(300, 300));

    /// Every control must sit inside the player box, at its natural size.
    for (final Finder control in <Finder>[
      find.byIcon(Icons.fullscreen_rounded),
      find.byType(Slider),
      find.byType(AnimatedIcon),
    ]) {
      final Rect rect = tester.getRect(control);
      expect(rect.isEmpty, isFalse, reason: '$control collapsed to zero size');

      /// Closed interval: the seek bar is meant to sit flush with the bottom
      /// edge, so `Rect.contains` (exclusive on right/bottom) is too strict.
      const double epsilon = 0.01;
      expect(
        rect.left >= playerRect.left - epsilon &&
            rect.top >= playerRect.top - epsilon &&
            rect.right <= playerRect.right + epsilon &&
            rect.bottom <= playerRect.bottom + epsilon,
        isTrue,
        reason: '$control ($rect) leaked outside the player box ($playerRect)',
      );
    }
  });

  testWidgets('controls keep the same geometry across every BoxFit',
      (tester) async {
    final Map<BoxFit, Rect> buttonRects = <BoxFit, Rect>{};

    for (final BoxFit fit in BoxFit.values) {
      await pumpPlayer(
        tester,
        SimplePlayerSettings.network(
          path: 'https://example.com/bee.mp4',
          aspectRatio: 1 / 1,
          fit: fit,
        ),
      );
      buttonRects[fit] = tester.getRect(find.byIcon(Icons.fullscreen_rounded));
    }

    final Rect reference = buttonRects[BoxFit.contain]!;
    for (final MapEntry<BoxFit, Rect> entry in buttonRects.entries) {
      expect(
        entry.value,
        reference,
        reason: 'the full screen button moved with fit: ${entry.key}',
      );
    }
  });

  testWidgets('the frame geometry follows the requested fit', (tester) async {
    /// 1920x1080 source inside a 300x300 player box.
    const Size box = Size(300, 300);
    const double videoRatio = 1920 / 1080;

    Future<Rect> frameRectFor(BoxFit fit) async {
      await pumpPlayer(
        tester,
        SimplePlayerSettings.network(
          path: 'https://example.com/bee.mp4',
          aspectRatio: 1 / 1,
          fit: fit,
        ),
      );
      return tester.getRect(find.byType(VideoPlayer));
    }

    /// contain: the full frame fits, letterboxed top/bottom.
    final Rect contain = await frameRectFor(BoxFit.contain);
    expect(contain.width, moreOrLessEquals(box.width));
    expect(contain.height, moreOrLessEquals(box.width / videoRatio));

    /// cover: the box is fully painted, the frame overflows sideways.
    final Rect cover = await frameRectFor(BoxFit.cover);
    expect(cover.height, moreOrLessEquals(box.height));
    expect(cover.width, moreOrLessEquals(box.height * videoRatio));
    expect(cover.width, greaterThan(box.width));

    /// fill: stretched to the box, aspect ratio is lost.
    final Rect fill = await frameRectFor(BoxFit.fill);
    expect(fill.size.width, moreOrLessEquals(box.width));
    expect(fill.size.height, moreOrLessEquals(box.height));
  });

  testWidgets('expand makes the player fill the parent box', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 120,
              child: SimplePlayer(
                simpleController: SimpleController(),
                simplePlayerSettings: SimplePlayerSettings.network(
                  path: 'https://example.com/bee.mp4',
                  expand: true,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.getRect(find.byType(SimplePlayer)).size, const Size(300, 120));
    expect(find.byType(AspectRatio), findsNothing);
  });
}
