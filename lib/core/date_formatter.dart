class DateFormatter {
  /// Formats [duration] the way players label a timeline: `m:ss`, growing to
  /// `h:mm:ss` only once the video passes an hour.
  String currentTime(Duration duration) {
    final Duration value = duration.isNegative ? Duration.zero : duration;
    final String seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    final int minutes = value.inMinutes.remainder(60);

    if (value.inHours > 0) {
      return '${value.inHours}:${minutes.toString().padLeft(2, '0')}:$seconds';
    }
    return '$minutes:$seconds';
  }
}
