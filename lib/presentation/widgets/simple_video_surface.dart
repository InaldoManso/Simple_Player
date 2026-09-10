import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Paints **only** the video texture, scaled according to [fit].
///
/// This widget is deliberately free of any control/HUD widget: it is meant to
/// be the bottom layer of a [Stack] whose upper layers hold the interface.
/// Because the scaling (and the clipping it may require) happens inside this
/// subtree, no [BoxFit] can ever crop or distort the player controls.
///
/// [FittedBox] only pushes a clip layer when the scaled child actually
/// overflows, so [BoxFit.contain] costs nothing extra, and the overflowing
/// fits ([BoxFit.cover], [BoxFit.fitWidth], ...) are resolved by a single
/// transform on the GPU-composited texture.
class SimpleVideoSurface extends StatelessWidget {
  final VideoPlayerController controller;
  final BoxFit fit;
  final Alignment alignment;

  const SimpleVideoSurface({
    super.key,
    required this.controller,
    required this.fit,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = controller.value.size;

    /// Until the first frame is decoded `size` can be `Size.zero`, which would
    /// give [FittedBox] a degenerate child to scale. Fall back to the reported
    /// aspect ratio, which the plugin always keeps sane.
    final bool hasSize = size.width > 0 && size.height > 0;
    final double width = hasSize ? size.width : controller.value.aspectRatio;
    final double height = hasSize ? size.height : 1.0;

    return SizedBox.expand(
      child: FittedBox(
        fit: fit,
        alignment: alignment,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: width,
          height: height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
