import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:scoped_model/scoped_model.dart';

class EventOptions extends Model {
  String? emptyText;
  Color emptyTextColor;
  IconData emptyIcon;
  Color emptyIconColor;
  Color backgroundColor;
  Color titleColor;
  Color descriptionColor;
  Color dateTimeColor;

  EventOptions(
      {this.emptyText,
      this.emptyTextColor = const Color(0xffe5e5e5),
      this.emptyIcon = Icons.reorder,
      this.emptyIconColor = const Color(0xffebebeb),
      this.backgroundColor = Colors.white,
      this.titleColor = Colors.black,
      this.descriptionColor = Colors.grey,
      this.dateTimeColor = Colors.grey});

  static EventOptions of(BuildContext context) =>
      ScopedModel.of<EventOptions>(context);
}
