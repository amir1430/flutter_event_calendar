import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_monthly_utils.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';
import 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/event_selector.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';
import 'package:flutter_event_calendar/src/models/calendar_options.dart';
import 'package:flutter_event_calendar/src/models/style/headers_options.dart';
import 'package:flutter_event_calendar/src/widgets/day.dart';

class CalendarMonthly extends StatefulWidget {
  Function onCalendarChanged;
  List<CalendarDateTime> specialDays;

  CalendarMonthly(
      {required this.specialDays, required this.onCalendarChanged, Key? key})
      : super();

  @override
  State<CalendarMonthly> createState() => _CalendarMonthlyState();
}

class _CalendarMonthlyState extends State<CalendarMonthly> {
  EventSelector eventSelector = EventSelector();
  late List<String> dayNames;
  late HeaderOptions headersStyle;
  int currDay = -1;
  int currMonth = -1;

  @override
  void initState() {
    headersStyle = HeaderOptions.of(context);
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
        children: [
          _buildDayName(),
          SizedBox(
            height: 12,
          ),
          _buildMonthView()
        ],
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
        final dayName = CalendarMonthlyUtils.getDayNameOfMonth(
            headersStyle, currMonth, EventCalendar.dateTime.day);
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
    final int firstDayIndex =
        CalendarMonthlyUtils.getFirstDayOfMonth(dayNames, headersStyle);
    final int lastDayIndex =
        firstDayIndex + CalendarMonthlyUtils.getLastDayOfMonth(headersStyle);
    final lastMonthLastDay =
        CalendarMonthlyUtils.getLastMonthLastDay(headersStyle);

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
                crossAxisCount: 7, mainAxisExtent: 40, mainAxisSpacing: 5),
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

  buildCurrentMonthDay(day) {
    final curYear = CalendarMonthlyUtils.getYear(currMonth);

    final CalendarDateTime? specialDay = CalendarUtils.getFromSpecialDay(
        widget.specialDays, curYear, currMonth, day);

    BoxDecoration? decoration =
        _getDecoration(specialDay, curYear, currMonth, day);

    return Day(
      dayEvents: eventSelector.getEventsByDayMonthYear(
        CalendarDateTime(year: curYear, month: currMonth, day: day),
      ),
      day: day,
      weekDay: '',
      dayStyle: DayStyle(
          mini: true,
          enabled: specialDay?.isEnableDay ?? false,
          selected: day == currDay,
          useUnselectedEffect: false,
          decoration: decoration),
      onCalendarChanged: () {
        CalendarUtils.goToDay(day);
        widget.onCalendarChanged.call();
      },
    );
  }

  buildNextMonthDay(int day) {
    final year = CalendarMonthlyUtils.getYear(currMonth + 1);
    final month = CalendarMonthlyUtils.getMonth(currMonth + 1);

    final CalendarDateTime? specialDay =
        CalendarUtils.getFromSpecialDay(widget.specialDays, year, month, day);

    BoxDecoration? decoration =
    _getDecoration(specialDay, year, month, day);

    return Day(
      day: day,
      weekDay: '',
      dayEvents: eventSelector.getEventsByDayMonthYear(
        CalendarDateTime(year: year, month: month, day: day),
      ),
      dayStyle: DayStyle(
        mini: true,
        enabled: specialDay?.isEnableDay ?? false,
        decoration: decoration,
        selected: false,
        useUnselectedEffect: true,
      ),
      onCalendarChanged: () {
        // reset to first to fix switching between 31/30/29 month lengths
        CalendarUtils.nextMonth();
        CalendarUtils.goToDay(day);
        widget.onCalendarChanged.call();
      },
    );
  }

  buildPrevMonthDay(int day) {
    final year = CalendarMonthlyUtils.getYear(currMonth - 1);
    final month = CalendarMonthlyUtils.getMonth(currMonth - 1);

    final CalendarDateTime? specialDay =
        CalendarUtils.getFromSpecialDay(widget.specialDays, year, month, day);

    BoxDecoration? decoration =
    _getDecoration(specialDay, year, month, day);

    return Day(
      day: day,
      dayEvents: eventSelector.getEventsByDayMonthYear(
          CalendarDateTime(year: year, month: month, day: day)),
      weekDay: '',
      dayStyle: DayStyle(
        mini: true,
        enabled: specialDay?.isEnableDay ?? false,
        selected: false,
        decoration: decoration,
        useUnselectedEffect: true,
      ),
      onCalendarChanged: () {
        // reset to first to fix switching between 31/30/29 month lengths
        CalendarUtils.previousMonth();
        CalendarUtils.goToDay(day);
        widget.onCalendarChanged.call();
      },
    );
  }

  BoxDecoration? _getDecoration(
      CalendarDateTime? specialDay, curYear, int currMonth, day) {
    BoxDecoration? decoration;
    final isStartRange =
        CalendarUtils.isStartOfRange(specialDay, curYear, currMonth, day);
    final isEndRange =
        CalendarUtils.isEndOfRange(specialDay, curYear, currMonth, day);
    final isInRange =
        CalendarUtils.isInRange(specialDay, curYear, currMonth, day);

    if (isEndRange && isStartRange) {
      decoration = BoxDecoration(
          color: specialDay?.color, borderRadius: BorderRadius.circular(8));
    } else if (isStartRange) {
      decoration = BoxDecoration(
          color: specialDay?.color,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(8)));
    } else if (isEndRange) {
      decoration = BoxDecoration(
          color: specialDay?.color,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(8)));
    } else if (isInRange) {
      decoration = BoxDecoration(color: specialDay?.color);
    }
    return decoration;
  }
}
