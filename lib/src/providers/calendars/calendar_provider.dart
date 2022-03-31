import '../../../flutter_event_calendar.dart';

abstract class CalendarProvider {
  bool isRTL();

  Map getMonthDays(WeekDayStringTypes type, int index);

  Map getMonthDaysShort(int index);

  EventDateTime getNextMonthDateTime();

  EventDateTime getPreviousMonthDateTime();

  EventDateTime getNextDayDateTime();

  EventDateTime getPreviousDayDateTime();

  EventDateTime getDateTime();

  EventDateTime goToMonth(index);

  EventDateTime goToDay(index);

  EventDateTime goToYear(int index);

  int getDateTimePart(PartFormat format);

  List<int> getYears();
}
