import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:scoped_model/scoped_model.dart';

class HeaderStyle extends Model {
  WeekDayStringTypes weekDayStringType;
  MonthStringTypes monthStringType;

  HeaderStyle({
    this.weekDayStringType = WeekDayStringTypes.FULL,
    this.monthStringType = MonthStringTypes.SHORT,
  });

  static HeaderStyle of(BuildContext context) =>
      ScopedModel.of<HeaderStyle>(context);
}
