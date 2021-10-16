import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class Event {
  late int listIndex;
  late String title;
  late String description;
  late CalendarDateTime dateTime;
  CalendarDateTime? fromDateTime;
  CalendarDateTime? toDateTime;
  late Function? onTap;
  late Function? onLongPress;

  Event({
    required this.title,
    String? description,
    required this.dateTime,
    this.fromDateTime,
    this.toDateTime,
    onTap(int listIndex)?,
    onLongPress,
  }) {
    this.description = description ?? '';
    this.onTap = onTap;
    this.onLongPress = onLongPress ??
        (int listIndex) {
          print('LongPress ' + listIndex.toString());
        };
  }
}
