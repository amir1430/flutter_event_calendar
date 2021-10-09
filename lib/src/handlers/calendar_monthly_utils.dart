import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';

class CalendarMonthlyUtils{
  static getYear(int month) {
    final year = CalendarUtils.getPartByInt(format: PartFormat.YEAR);
    if (month > 12)
      return year + 1;
    else if (month < 1) return year - 1;
    return year;
  }

  static getMonth(int month) {
    if (month > 12)
      return 1;
    else if (month < 1) return 1;
    return month;
  }

  static int getFirstDayOfMonth(List<String> dayNames,HeaderStyle headersStyle) {
    final currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    final monthDays = CalendarUtils.getMonthDays(headersStyle.weekDayStringType, currentMonth);
    return dayNames.indexOf(monthDays[1]);
  }

  static String getDayNameOfMonth(HeaderStyle headersStyle,int currMonth,int index) {
    final dayName = EventCalendar.calendarProvider
        .getMonthDays(headersStyle.weekDayStringType, currMonth)[index];
    return dayName;
  }

  static int getLastDayOfMonth(HeaderStyle headersStyle) {
    final currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    return CalendarUtils.getDays(headersStyle.weekDayStringType, currentMonth)
        .keys
        .last;
  }

  static int getLastMonthLastDay(HeaderStyle headersStyle) {
    final cMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    if (cMonth - 1 < 1) {
      return -1;
    }
    return CalendarUtils.getDays(headersStyle.weekDayStringType, cMonth - 1)
        .keys
        .last;
  }

}