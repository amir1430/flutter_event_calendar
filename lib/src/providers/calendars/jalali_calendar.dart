import 'dart:ui';

import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';
import 'package:flutter_event_calendar/src/providers/calendars/calendar_provider.dart';
import 'package:flutter_event_calendar/src/utils/calendar_types.dart';
import 'package:shamsi_date/shamsi_date.dart';

class JalaliCalendar extends CalendarProvider {
  @override
  EventDateTime getDateTime() {
    final f = Jalali.now().formatter;

    return EventDateTime(
        year: int.parse(f.yyyy), month: int.parse(f.mm), day: int.parse(f.dd));
  }

  @override
  EventDateTime getNextMonthDateTime() {
    final date = _getSelectedDate();
    final newDate = date.withDay(1).addMonths(1);
    final f = newDate.formatter;
    return EventDateTime(year: int.parse(f.y), month: int.parse(f.mm), day: 01);
  }

  @override
  EventDateTime getPreviousMonthDateTime() {
    final date = _getSelectedDate();
    dynamic newDate = date.withDay(1).addMonths(-1);
    final f = newDate.formatter;
    return EventDateTime(year: int.parse(f.y), month: int.parse(f.mm), day: 01);
  }

  @override
  EventDateTime getPreviousDayDateTime() {
    dynamic date = _getSelectedDate();
    dynamic newDate = date.addDays(-1);
    final f = newDate.formatter;
    return EventDateTime(
        year: int.parse(f.y), month: int.parse(f.mm), day: int.parse(f.dd));
  }

  @override
  EventDateTime getNextDayDateTime() {
    dynamic date = _getSelectedDate();
    dynamic newDate = date.addDays(1);
    final f = newDate.formatter;
    return EventDateTime(
        year: int.parse(f.y), month: int.parse(f.mm), day: int.parse(f.dd));
  }

  @override
  bool isRTL() => Translator.isRTL();

  @override
  Map getMonthDays(WeekDayStringTypes type,int index) {
    Map days = {};
    Jalali firstDayOfMonth = _getSelectedDate().withMonth(index).withDay(1);
    int dayIndex = firstDayOfMonth.weekDay - 1;
    switch (type) {
      case WeekDayStringTypes.FULL:
        for (var i = 1; i <= firstDayOfMonth.monthLength; i++) {
          days[i] = Translator.getFullNameOfDays()[dayIndex % 7];
          dayIndex++;
        }
        break;
      case WeekDayStringTypes.SHORT:
        for (var i = 1; i <= firstDayOfMonth.monthLength; i++) {
          days[i] = Translator.getShortNameOfDays()[dayIndex % 7];
          dayIndex++;
        }
        break;
    }
    return days;
  }

  @override
  List<int> getYears() {
    int year = _getSelectedDate().year;
    List<int> years = [];
    for (var i = -100; i <= 50; i++) years.add(year + i);
    return years;
  }

  Jalali _getSelectedDate() {
    Jalali jv = Jalali(
      EventCalendar.dateTime.year,
      EventCalendar.dateTime.month,
      EventCalendar.dateTime.day,
    );
    return jv;
  }

  @override
  EventDateTime goToDay(index) {
    dynamic date = _getSelectedDate();
    final f = date.formatter;
    return EventDateTime(year: int.parse(f.y), month: int.parse(f.mm), day: index);
  }

  @override
  EventDateTime goToMonth(index) {
    dynamic date = _getSelectedDate();
    final f = date.formatter;
    return EventDateTime(year: int.parse(f.y), month: index, day: 01);
  }

  @override
  EventDateTime goToYear(index) {
    dynamic date = _getSelectedDate();
    final f = date.formatter;
    return EventDateTime(year: index, month: int.parse(f.mm), day: 01);
  }

  @override
  int getDateTimePart(PartFormat format) {
    Jalali date = _getSelectedDate();
    switch (format) {
      case PartFormat.YEAR:
        return date.year;
      case PartFormat.MONTH:
        return date.month;
      case PartFormat.DAY:
        return date.day;
    }
  }

  @override
  Map getMonthDaysShort(int index) {
    Map days = {};
    Jalali firstDayOfMonth = _getSelectedDate().withMonth(index).withDay(1);
    int dayIndex = firstDayOfMonth.weekDay - 1;
    for (var i = 1; i <= firstDayOfMonth.monthLength; i++) {
      days[i] = Translator.getShortNameOfDays()[dayIndex % 7];
      dayIndex++;
    }
    return days;
  }
}
