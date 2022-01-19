import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/src/models/event.dart';
import 'package:flutter_event_calendar/src/models/style/event_options.dart';

class EventCard extends StatelessWidget {
  Event fullCalendarEvent;

  EventCard({required this.fullCalendarEvent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 7, right: 7),
      child: GestureDetector(
        onTap: (() {
          fullCalendarEvent.onTap?.call(fullCalendarEvent.listIndex);
        }),
        onLongPress: (() {
          fullCalendarEvent.onLongPress?.call(fullCalendarEvent.listIndex);
        }),
        child: fullCalendarEvent.child,
      ),
    );
  }
}
