import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedStr => DateFormat.yMMMMEEEEd().format(this);
}
