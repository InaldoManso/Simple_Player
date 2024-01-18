// ignore_for_file: import_of_legacy_library_into_null_safe

class DateFormatter {
  /// The function takes a duration and returns the current time in the format "hour:minutes:seconds" or
  /// "minutes:seconds" if the duration is less than an hour.
  ///
  /// Args:
  ///   duration (Duration): The `duration` parameter is of type `Duration`. It represents a length of
  /// time, such as a duration of hours, minutes, and seconds.
  ///
  /// Returns:
  ///   a formatted string representing the current time. If the duration has a non-zero hour component,
  /// the string will be in the format "hour:minutes:seconds". Otherwise, the string will be in the format
  /// "minutes:seconds".
  String currentTime(Duration duration) {
    List<String> list = duration.toString().split(':');
    String hour = list[0];
    String minutes = list[1];
    String seconds = list[2].split('.')[0];

    /// String milliseconds = list[2].split('.')[1];

    if (hour != '0') {
      return '$hour:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
}
