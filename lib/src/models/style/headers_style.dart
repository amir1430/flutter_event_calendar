import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:scoped_model/scoped_model.dart';

class HeadersStyle extends Model {
  WeekDayStringTypes weekDayStringType;
  MonthStringTypes monthStringType;

  HeadersStyle({
    this.weekDayStringType = WeekDayStringTypes.FULL,
    this.monthStringType = MonthStringTypes.SHORT,
  });

  static HeadersStyle of(BuildContext context) =>
      ScopedModel.of<HeadersStyle>(context);
}
