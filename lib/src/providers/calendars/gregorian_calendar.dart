import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';
import 'package:flutter_event_calendar/src/providers/calendars/calendar_provider.dart';
import 'package:flutter_event_calendar/src/utils/calendar_types.dart';

class GregorianCalendar extends CalendarProvider {
  @override
  CalendarDateTime getDateTime() {
    return CalendarDateTime.parse(DateTime.now().toString())!;
  }

  @override
  CalendarDateTime getNextMonthDateTime() {
    final date = _getSelectedDate();
    return CalendarDateTime.parse(
        DateTime(date.year, date.month + 1, 1).toString())!;
  }

  @override
  CalendarDateTime getPreviousMonthDateTime() {
    final date = _getSelectedDate();
    return CalendarDateTime.parse(
        DateTime(date.year, date.month - 1, 1).toString())!;
  }

  @override
  CalendarDateTime getPreviousDayDateTime() {
    final date = _getSelectedDate();
    return CalendarDateTime(year: date.year, month: date.month, day: date.day - 1);
  }

  @override
  CalendarDateTime getNextDayDateTime() {
    final date = _getSelectedDate();
    return CalendarDateTime(year: date.year, month: date.month, day: date.day + 1);
  }

  @override
  bool isRTL() => Translator.isRTL();

  @override
  Map getMonthDays(WeekDayStringTypes type, int index) {
    Map days = {};
    CalendarDateTime now = _getSelectedDate();
    int monthLength = DateTime(now.year, index + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(now.year, index, 1);
    int dayIndex = firstDayOfMonth.weekday;

    switch (type) {
      case WeekDayStringTypes.FULL:
        for (var i = 1; i <= monthLength; i++) {
          days[i] = Translator.getFullNameOfDays()[dayIndex % 7];
          dayIndex++;
        }
        break;
      case WeekDayStringTypes.SHORT:
        for (var i = 1; i <= monthLength; i++) {
          days[i] = Translator.getShortNameOfDays()[dayIndex % 7];
          dayIndex++;
        }
        break;
    }
    return days;
  }

  @override
  Map getMonthDaysShort(int index) {
    Map days = {};
    CalendarDateTime now = _getSelectedDate();
    int monthLength = DateTime(now.year, index + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(now.year, index, 1);
    int dayIndex = firstDayOfMonth.weekday;
    for (var i = 1; i <= monthLength; i++) {
      days[i] = Translator.getShortNameOfDays()[dayIndex % 7];
      dayIndex++;
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

  CalendarDateTime _getSelectedDate() {
    return EventCalendar.dateTime;
  }

  @override
  CalendarDateTime goToDay(index) {
    dynamic date = _getSelectedDate();
    return CalendarDateTime(year: date.year, month: date.month, day: index);
  }

  @override
  CalendarDateTime goToMonth(index) {
    dynamic date = _getSelectedDate();
    return CalendarDateTime(year: date.year, month: index, day: 1);
  }

  @override
  CalendarDateTime goToYear(index) {
    dynamic date = _getSelectedDate();
    return CalendarDateTime(year: index, month: date.month, day: 1);
  }

  @override
  int getDateTimePart(PartFormat format) {
    CalendarDateTime date = _getSelectedDate();
    switch (format) {
      case PartFormat.YEAR:
        return date.year;
      case PartFormat.MONTH:
        return date.month;
      case PartFormat.DAY:
        return date.day;
    }
  }
}
