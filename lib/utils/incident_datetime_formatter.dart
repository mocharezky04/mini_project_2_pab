import 'package:intl/intl.dart';

final DateFormat _displayDateTimeFormat = DateFormat('dd-MM-yyyy HH:mm');

String formatIncidentDateTime(DateTime value) {
  return _displayDateTimeFormat.format(value.toLocal());
}

DateTime parseIncidentDateTime(String input) {
  return _displayDateTimeFormat.parseStrict(input);
}
