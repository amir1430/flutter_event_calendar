import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';
import 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/event_selector.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';
import 'package:flutter_event_calendar/src/models/calendar_options.dart';
import 'package:flutter_event_calendar/src/models/style/headers_style.dart';
import 'package:flutter_event_calendar/src/widgets/day.dart';

class CalendarMonthly extends StatefulWidget {
  Function onCalendarChanged;
  List<EventDateTime> enabledDays;
  List<EventDateTime> disabledDays;
  List<EventDateTime> colorizedDays;

  CalendarMonthly(
      {required this.enabledDays,
      required this.disabledDays,
      required this.colorizedDays,
      required this.onCalendarChanged,
      Key? key})
      : super();

  @override
  State<CalendarMonthly> createState() => _CalendarMonthlyState();
}

class _CalendarMonthlyState extends State<CalendarMonthly> {
  EventSelector eventSelector = EventSelector();
  late List<String> dayNames;
  late HeadersStyle headersStyle;
  int currDay = -1;
  int currMonth = -1;

  @override
  void initState() {
    headersStyle = HeadersStyle.of(context);
    dayNames = Translator.getNameOfDay(headersStyle.weekDayStringType);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    currDay = CalendarUtils.getPartByInt(format: PartFormat.DAY);
    currMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CalendarMonthly oldWidget) {
    dayNames = Translator.getNameOfDay(headersStyle.weekDayStringType);
    currDay = CalendarUtils.getPartByInt(format: PartFormat.DAY);
    currMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildDayName(), _buildMonthView()],
      ),
    );
  }

  _buildDayName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: EventCalendar.calendarProvider.isRTL()
          ? TextDirection.rtl
          : TextDirection.ltr,
      children: List.generate(7, (index) {
        final dayName = getDayNameOfMonth(EventCalendar.dateTime.day);
        return Expanded(
          child: Center(
            heightFactor: 1,
            child: RotatedBox(
              quarterTurns:
                  headersStyle.weekDayStringType == WeekDayStringTypes.FULL
                      ? 3
                      : 0,
              child: Text(
                dayNames[index],
                style: TextStyle(
                    color: dayNames[index] == dayName ? Colors.red : null,
                    fontSize: 15,
                    fontFamily: CalendarOptions.of(context).font),
              ),
            ),
          ),
        );
      }),
    );
  }

  _buildMonthView() {
    final int firstDayIndex = getFirstDayOfMonth();
    final int lastDayIndex = firstDayIndex + getLastDayOfMonth();
    final lastMonthLastDay = getLastMonthLastDay();

    return SizedBox(
      height: 7 * 40,
      child: Directionality(
        textDirection: EventCalendar.calendarProvider.isRTL()
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisExtent: 45),
            itemBuilder: (context, index) => _buildItem(
                index, firstDayIndex, lastDayIndex, lastMonthLastDay)),
      ),
    );
  }

  _buildItem(
      int index, int firstDayIndex, int lastDayIndex, int lastMonthLastDay) {
    int day = -1;

    final isCurrentMonthDays = index >= firstDayIndex && index < lastDayIndex;
    final isNextMonthDays = index >= lastDayIndex;

    if (isCurrentMonthDays)
      day = index - firstDayIndex + 1;
    else if (isNextMonthDays)
      day = index - lastDayIndex + 1;
    else
      day = lastMonthLastDay - (firstDayIndex - index) + 1;

    if (isCurrentMonthDays) {
      return buildCurrentMonthDay(day);
    } else if (isNextMonthDays) {
      return buildNextMonthDay(day);
    } else if (day > 0) {
      return buildPrevMonthDay(day);
    }
    return SizedBox();
  }

  int getFirstDayOfMonth() {
    final currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    final monthDays = CalendarUtils.getMonthDays(
        HeadersStyle.of(context).weekDayStringType, currentMonth);
    return dayNames.indexOf(monthDays[1]);
  }

  String getDayNameOfMonth(index) {
    final dayName = EventCalendar.calendarProvider
        .getMonthDays(headersStyle.weekDayStringType, currMonth)[index];
    return dayName;
  }

  int getLastDayOfMonth() {
    final currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    return CalendarUtils.getDays(headersStyle.weekDayStringType, currentMonth)
        .keys
        .last;
  }

  int getLastMonthLastDay() {
    final cMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    if (cMonth - 1 < 1) {
      return -1;
    }
    return CalendarUtils.getDays(headersStyle.weekDayStringType, cMonth - 1)
        .keys
        .last;
  }

  getMonth(int month) {
    if (month > 12)
      return 1;
    else if (month < 1) return 1;
    return month;
  }

  getYear(int month) {
    final year = CalendarUtils.getPartByInt(format: PartFormat.YEAR);
    if (month > 12)
      return year + 1;
    else if (month < 1) return year - 1;
    return year;
  }

  buildCurrentMonthDay(day) {
    final curYear = getYear(currMonth);
    final isEnable = isDayEnabled(curYear, currMonth, day);

    final EventDateTime? colorizedDay = CalendarUtils.getColorizedDay(
        widget.colorizedDays, curYear, currMonth, day);

    return Center(
      child: Day(
        dayEvents: eventSelector.getEventsByDayMonthYear(
          EventDateTime(year: curYear, month: currMonth, day: day),
        ),
        day: day,
        weekDay: '',
        color: colorizedDay?.color,
        enabled: isEnable,
        selected: day == currDay,
        onCalendarChanged: () {
          CalendarUtils.goToDay(day);
          widget.onCalendarChanged.call();
        },
        mini: true,
      ),
    );
  }

  buildNextMonthDay(int day) {
    final year = getYear(currMonth + 1);
    final month = getMonth(currMonth + 1);
    final isEnable = isDayEnabled(year, month, day);

    final EventDateTime? colorizedDay =
        CalendarUtils.getColorizedDay(widget.colorizedDays, year, month, day);

    return Center(
        child: Day(
            day: day,
            useUnselectedEffect: true,
            weekDay: '',
            color: colorizedDay?.color,
            dayEvents: eventSelector.getEventsByDayMonthYear(EventDateTime(
                year: year, month: getMonth(currMonth + 1), day: day)),
            enabled: isEnable,
            onCalendarChanged: () {
              // reset to first to fix switching between 31/30/29 month lengths
              CalendarUtils.nextMonth();
              CalendarUtils.goToDay(day);
              widget.onCalendarChanged.call();
            },
            selected: false,
            mini: true));
  }

  buildPrevMonthDay(int day) {
    final year = getYear(currMonth - 1);
    final month = getMonth(currMonth - 1);

    final isEnable = isDayEnabled(year, month, day);

    final EventDateTime? colorizedDay =
        CalendarUtils.getColorizedDay(widget.colorizedDays, year, month, day);

    return Center(
        child: Day(
            day: day,
            useUnselectedEffect: true,
            dayEvents: eventSelector.getEventsByDayMonthYear(
                EventDateTime(year: year, month: month, day: day)),
            weekDay: '',
            color: colorizedDay?.color,
            enabled: isEnable,
            onCalendarChanged: () {
              // reset to first to fix switching between 31/30/29 month lengths
              CalendarUtils.previousMonth();
              CalendarUtils.goToDay(day);
              widget.onCalendarChanged.call();
            },
            selected: false,
            mini: true));
  }

  isDayEnabled(curYear, int currMonth, day) {
    return CalendarUtils.isEnabledDay(
            widget.enabledDays, curYear, currMonth, day) &&
        !CalendarUtils.isDisabledDay(
            widget.disabledDays, curYear, currMonth, day);
  }
}
