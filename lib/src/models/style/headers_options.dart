import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:scoped_model/scoped_model.dart';

class HeaderOptions extends Model {
  WeekDayStringTypes weekDayStringType;
  MonthStringTypes monthStringType;

  HeaderOptions({
    this.weekDayStringType = WeekDayStringTypes.FULL,
    this.monthStringType = MonthStringTypes.SHORT,
  });

  static HeaderOptions of(BuildContext context) =>
      ScopedModel.of<HeaderOptions>(context);
}
