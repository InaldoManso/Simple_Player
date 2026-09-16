import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_player/simple_player.dart';
import 'package:simple_player/presentation/simple_player_fullscreen.dart';
import 'package:video_player/video_player.dart';

import 'fake_video_player_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => FakeVideoPlayerPlatform.register());

  Future<void> pumpPlayer(
    WidgetTester tester, {
    required bool autoPlay,
    required bool muteOnAutoPlay,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              height: 180,
              child: SimplePlayer(
                simpleController: SimpleController(),
                simplePlayerSettings: SimplePlayerSettings.network(
                  path: 'https://example.com/bee.mp4',
                  label: 'Bee',
                  autoPlay: autoPlay,
                  muteOnAutoPlay: muteOnAutoPlay,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  double volume(WidgetTester tester) {
    return tester
        .widgetList<VideoPlayer>(find.byType(VideoPlayer))
        .first
        .controller
        .value
        .volume;
  }

  final Finder badge = find.byIcon(Icons.volume_off_rounded);

  test('muteOnAutoPlay defaults to false', () {
    expect(
      SimplePlayerSettings.network(path: 'https://a/b.mp4').muteOnAutoPlay,
      isFalse,
    );
  });

  testWidgets('starts silent and flags it with a badge', (tester) async {
    await pumpPlayer(tester, autoPlay: true, muteOnAutoPlay: true);

    expect(volume(tester), 0);
    expect(badge, findsOneWidget);
  });

  testWidgets('tapping the badge turns the sound on and hides it',
      (tester) async {
    await pumpPlayer(tester, autoPlay: true, muteOnAutoPlay: true);

    await tester.tap(badge);
    await tester.pump();

    expect(volume(tester), 1);
    expect(badge, findsNothing);
  });

  testWidgets('the badge outlives the auto hide of the interface',
      (tester) async {
    await pumpPlayer(tester, autoPlay: true, muteOnAutoPlay: true);

    /// Past the 3s auto hide: the controls fade, the badge must not.
    await tester.pump(const Duration(seconds: 4));

    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity).first).opacity,
      0,
    );
    expect(badge, findsOneWidget);

    await tester.tap(badge);
    await tester.pump();
    expect(volume(tester), 1);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('no badge without muteOnAutoPlay', (tester) async {
    await pumpPlayer(tester, autoPlay: true, muteOnAutoPlay: false);

    expect(volume(tester), 1);
    expect(badge, findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('muteOnAutoPlay is ignored when autoPlay is off',
      (tester) async {
    await pumpPlayer(tester, autoPlay: false, muteOnAutoPlay: true);

    expect(volume(tester), 1);
    expect(badge, findsNothing);
  });

  testWidgets('pressing full screen turns the sound on', (tester) async {
    await pumpPlayer(tester, autoPlay: true, muteOnAutoPlay: true);
    expect(volume(tester), 0);

    await tester.tap(find.byIcon(Icons.fullscreen_rounded));
    await tester.pump();

    /// The route itself needs real platform channels, but the unmute happens
    /// before any of them.
    expect(volume(tester), 1);
    expect(badge, findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the full screen player never shows the badge, even if muted',
      (tester) async {
    /// `initialize()` needs the real event loop; awaiting it straight inside
    /// testWidgets would hang on the fake clock.
    late final VideoPlayerController controller;
    await tester.runAsync(() async {
      controller = VideoPlayerController.networkUrl(
        Uri.parse('https://example.com/b.mp4'),
      );
      await controller.initialize();
      await controller.setVolume(0);
    });
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SimplePlayerFullScreen(
          videoPlayerController: controller,
          simpleController: SimpleController(),
          simplePlayerSettings: SimplePlayerSettings.network(
            path: 'https://example.com/b.mp4',
            label: 'Bee',
            muteOnAutoPlay: true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(controller.value.volume, 0);
    expect(find.byIcon(Icons.fullscreen_exit_rounded), findsOneWidget);
    expect(badge, findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
