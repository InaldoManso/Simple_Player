import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_player/simple_player.dart';

import 'fake_video_player_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => FakeVideoPlayerPlatform.register());

  Future<void> pumpPlayer(
    WidgetTester tester, {
    bool autoPlay = false,
    String label = 'Bee',
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
                  label: label,
                  autoPlay: autoPlay,
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

  /// The interface is faded, not unmounted, so opacity is what tells them apart.
  double hudOpacity(WidgetTester tester) {
    return tester
        .widget<AnimatedOpacity>(find.byType(AnimatedOpacity).first)
        .opacity;
  }

  testWidgets('shows only the minimal set of controls', (tester) async {
    await pumpPlayer(tester);

    expect(find.text('Bee'), findsOneWidget);
    expect(find.byType(AnimatedIcon), findsOneWidget);
    expect(find.text('0:00 / 0:10'), findsOneWidget);
    expect(find.byIcon(Icons.fullscreen_rounded), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);

    /// The old settings popup is gone for good.
    expect(find.byIcon(Icons.settings_outlined), findsNothing);
    expect(find.byIcon(Icons.nights_stay), findsNothing);
    expect(find.byIcon(Icons.slow_motion_video_rounded), findsNothing);
  });

  testWidgets('hides the title row when no label is given', (tester) async {
    await pumpPlayer(tester, label: '');

    expect(find.text('Bee'), findsNothing);
    expect(find.byType(AnimatedIcon), findsOneWidget);
  });

  testWidgets('auto hides while playing and comes back on tap',
      (tester) async {
    await pumpPlayer(tester, autoPlay: true);
    expect(hudOpacity(tester), 1);

    /// Past the 3s auto hide delay.
    await tester.pump(const Duration(seconds: 4));
    expect(hudOpacity(tester), 0);

    await tester.tap(find.byType(SimplePlayer));
    await tester.pump();
    expect(hudOpacity(tester), 1);

    /// Nothing is left pending once the tree goes away.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('stays visible while the video is paused', (tester) async {
    await pumpPlayer(tester);

    await tester.pump(const Duration(seconds: 5));
    expect(hudOpacity(tester), 1);
  });
}
