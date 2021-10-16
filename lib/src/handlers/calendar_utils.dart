import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
import 'package:flutter_event_calendar/src/models/style/headers_options.dart';
import 'package:flutter_event_calendar/src/utils/calendar_types.dart';
import 'translator.dart';
import 'package:collection/collection.dart';

class CalendarUtils {
  static goToYear(index) {
    EventCalendar.dateTime = EventCalendar.calendarProvider.goToYear(index);
  }

  static goToMonth(index) {
    EventCalendar.dateTime = EventCalendar.calendarProvider.goToMonth(index);
  }

  static goToDay(index) {
    EventCalendar.dateTime = EventCalendar.calendarProvider.goToDay(index);
  }

  static nextDay() {
    EventCalendar.dateTime =
        EventCalendar.calendarProvider.getNextDayDateTime();
  }

  static previousDay() {
    EventCalendar.dateTime =
        EventCalendar.calendarProvider.getPreviousDayDateTime();
  }

  static nextMonth() {
    EventCalendar.dateTime =
        EventCalendar.calendarProvider.getNextMonthDateTime();
  }

  static previousMonth() {
    EventCalendar.dateTime =
        EventCalendar.calendarProvider.getPreviousMonthDateTime();
  }

  static List getYears() => EventCalendar.calendarProvider.getYears();

  static Map getDays(WeekDayStringTypes type, int monthIndex) =>
      EventCalendar.calendarProvider.getMonthDays(type, monthIndex);

  static Map getMonthDays(WeekDayStringTypes type, int monthIndex) =>
      EventCalendar.calendarProvider.getMonthDays(type, monthIndex);

  static getPartByString(
      {required PartFormat format, required HeaderOptions options}) {
    return Translator.getPartTranslate(options, format,
        EventCalendar.calendarProvider.getDateTimePart(format) - 1);
  }

  static getPartByInt({required PartFormat format}) {
    return EventCalendar.calendarProvider.getDateTimePart(format);
  }

  static CalendarDateTime? getFromSpecialDay(
      List<CalendarDateTime> specialDays, int year, int month, int day) {
    return specialDays.firstWhereOrNull((element) => _isRange(element)
        ? isInRange(element, year, month, day)
        : element.isDateEqualByInt(year, month, day));
  }

  static _isRange(CalendarDateTime element) =>
      element.toMonth != null || element.toDay != null;

  static isEndOfRange(
          CalendarDateTime? element, int year, int month, int day) =>
      element?.year == year &&
      (element?.toMonth == month || element?.month == month) &&
      element?.toDay == day;

  static isStartOfRange(
          CalendarDateTime? element, int year, int month, int day) =>
      element?.year == year && element?.month == month && element?.day == day;

  static isInRange(
      CalendarDateTime? selectedDatetime, int year, int month, int day) {
    if (selectedDatetime?.year != year)
      return false;
    if (selectedDatetime?.month != null && selectedDatetime!.month > month)
      return false;
    if (selectedDatetime?.toMonth != null && selectedDatetime!.toMonth! < month)
      return false;
    if (selectedDatetime?.day != null && selectedDatetime!.month == month && selectedDatetime.day > day)
      return false;

    if (selectedDatetime?.toMonth != null) {
      if (selectedDatetime!.toDay != null &&
          selectedDatetime.toMonth == month &&
          selectedDatetime.toDay! < day)
        return false;
    }else{
      if (selectedDatetime!.toDay != null &&
          selectedDatetime.month == month &&
          selectedDatetime.toDay! < day)
        return false;
    }
    return true;
  }
}
