class DateHelper {
  static const format = 'dd MMMM yyyy';

  DateTime dateTime;

  int get timestamp => dateTime.millisecondsSinceEpoch ~/ 1000;

  DateHelper({required this.dateTime});

  static DateTime fromTimestamp(int timestamp) {
   return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
}