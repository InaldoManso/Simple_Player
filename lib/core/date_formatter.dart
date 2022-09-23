// ignore_for_file: import_of_legacy_library_into_null_safe

class DateFormatter {
  String currentTime(Duration duration) {
    List<String> list = duration.toString().split(':');
    String hour = list[0];
    String minutes = list[1];
    String seconds = list[2].split('.')[0];
    //String milliseconds = list[2].split('.')[1];

    if (hour != '0') {
      return '$hour:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
}
