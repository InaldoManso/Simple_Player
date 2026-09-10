import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../core/date_formatter.dart';

/// The interface layer of the player.
///
/// It is rendered as a sibling of `SimpleVideoSurface` inside a [Stack], never
/// as its child, so it always receives the full player box as its constraints —
/// whatever [BoxFit] the video underneath is using.
///
/// The layout is deliberately minimal: a title over a top scrim, one central
/// play/pause button and a bottom bar with the elapsed time, the full screen
/// toggle and an edge to edge seek bar.
class SimplePlayerControls extends StatelessWidget {
  final String title;
  final Color colorAccent;
  final bool visible;
  final bool isFullScreen;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final Duration buffered;
  final Animation<double> playPauseProgress;
  final VoidCallback onTap;
  final VoidCallback onPlayPause;
  final VoidCallback onFullScreen;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<bool> onScrubbing;

  const SimplePlayerControls({
    super.key,
    required this.title,
    required this.colorAccent,
    required this.visible,
    required this.isFullScreen,
    required this.isBuffering,
    required this.position,
    required this.duration,
    required this.buffered,
    required this.playPauseProgress,
    required this.onTap,
    required this.onPlayPause,
    required this.onFullScreen,
    required this.onSeek,
    required this.onScrubbing,
  });

  static final DateFormatter _formatter = DateFormatter();

  @override
  Widget build(BuildContext context) {
    /// The detector sits outside the fade so a tap brings the interface back
    /// while it is hidden; [IgnorePointer] keeps the faded out buttons inert.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: !visible,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildScrim(),

              /// The scrim stays edge to edge; only the interactive parts are
              /// pushed away from notches and rounded corners.
              SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildTitle(),
                    _buildPlayPause(),
                    _buildBottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Two soft gradients instead of a flat veil, so the video stays readable
  /// behind the title and the seek bar without dimming the whole frame.
  Widget _buildScrim() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: <double>[0.0, 0.28, 0.62, 1.0],
          colors: <Color>[
            Color(0x8A000000),
            Color(0x00000000),
            Color(0x00000000),
            Color(0xA6000000),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (title.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPause() {
    return Center(
      child: SizedBox(
        width: 64,
        height: 64,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0x59000000),
            shape: BoxShape.circle,
          ),
          child: isBuffering
              ? Padding(
                  padding: const EdgeInsets.all(18),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorAccent,
                  ),
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  icon: AnimatedIcon(
                    size: 34,
                    color: Colors.white,
                    icon: AnimatedIcons.play_pause,
                    progress: playPauseProgress,
                    semanticLabel: 'Play or pause',
                  ),
                  onPressed: onPlayPause,
                ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Row(
              children: [
                Text(
                  '${_formatter.currentTime(position)}'
                  ' / '
                  '${_formatter.currentTime(duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isFullScreen
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                    color: Colors.white,
                    size: 26,
                    semanticLabel:
                        isFullScreen ? 'Exit full screen' : 'Full screen',
                  ),
                  onPressed: onFullScreen,
                ),
              ],
            ),
          ),
          _buildTimeline(),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final double total = duration.inMilliseconds.toDouble();
    if (total <= 0) return const SizedBox(height: 24);

    /// The position listener and a drag can be a frame apart, so both values
    /// are clamped to keep [Slider] out of an assertion.
    final double value = position.inMilliseconds.toDouble().clamp(0, total);
    final double secondary =
        buffered.inMilliseconds.toDouble().clamp(value, total);

    return SliderTheme(
      data: Constants.timelineTheme(colorAccent),
      child: Slider(
        value: value,
        secondaryTrackValue: secondary,
        max: total,
        min: 0,
        onChangeStart: (_) => onScrubbing(true),
        onChangeEnd: (_) => onScrubbing(false),
        onChanged: (double milliseconds) =>
            onSeek(Duration(milliseconds: milliseconds.toInt())),
      ),
    );
  }
}
