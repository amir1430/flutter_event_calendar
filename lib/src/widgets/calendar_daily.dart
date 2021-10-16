import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';
import 'package:flutter_event_calendar/src/handlers/event_selector.dart';
import 'package:flutter_event_calendar/src/models/style/headers_options.dart';
import 'package:flutter_event_calendar/src/widgets/day.dart';

class CalendarDaily extends StatelessWidget {
  Function? onCalendarChanged;
  var dayIndex;
  late ScrollController animatedTo;
  EventSelector selector = EventSelector();
  List<CalendarDateTime> specialDays;

  CalendarDaily(
      {this.onCalendarChanged,
      required this.specialDays})
      : super() {
    dayIndex = CalendarUtils.getPartByInt(format: PartFormat.DAY);
  }

  @override
  Widget build(BuildContext context) {
    animatedTo = ScrollController(
        initialScrollOffset: (HeaderOptions.of(context).weekDayStringType ==
                    WeekDayStringTypes.FULL
                ? 80.0
                : 60.0) *
            (dayIndex - 1));

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      animatedTo.animateTo(
          (HeaderOptions.of(context).weekDayStringType ==
                      WeekDayStringTypes.FULL
                  ? 80.0
                  : 60.0) *
              (dayIndex - 1),
          duration: Duration(milliseconds: 700),
          curve: Curves.decelerate);
    });

    // Yearly , Monthly , Weekly and Daily calendar
    return Container(
      height: 130,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListView(
                    reverse: EventCalendar.calendarProvider.isRTL(),
                    controller: animatedTo,
                    scrollDirection: Axis.horizontal,
                    children: daysMaker(context),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IgnorePointer(
                child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xffffffff),
                        const Color(0x0affffff)
                      ],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IgnorePointer(
                child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        const Color(0xffffffff),
                        const Color(0x0affffff)
                      ],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> daysMaker(BuildContext context) {
    final currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    final currentYear = CalendarUtils.getPartByInt(format: PartFormat.YEAR);

    final headersStyle = HeaderOptions.of(context);

    List<Widget> days = [
      SizedBox(
          width: headersStyle.weekDayStringType == WeekDayStringTypes.FULL
              ? 80
              : 60)
    ];

    int day = dayIndex;

    CalendarUtils.getDays(headersStyle.weekDayStringType, currentMonth)
        .forEach((index, weekDay) {

      final CalendarDateTime? specialDay =
      CalendarUtils.getFromSpecialDay(specialDays, currentYear, currentMonth, index);

      var selected = index == day ? true : false;
      days.add(Day(
        day: index,
        dayEvents: selector.getEventsByDayMonthYear(
          CalendarDateTime(year: currentYear, month: currentMonth, day: index),
        ),
        dayStyle: DayStyle(
          mini: false,
          enabled: specialDay?.isEnableDay ?? false,
          selected: selected,
          useUnselectedEffect: true,
        ),
        weekDay: weekDay,
        onCalendarChanged: () {
          CalendarUtils.goToDay(index);
          onCalendarChanged?.call();
        },
      ));
    });

    days.add(SizedBox(
        width: headersStyle.weekDayStringType == WeekDayStringTypes.FULL
            ? 80
            : 60));

    return days;
  }

  // bool isEnabledDay(int cYear, int cMonth, int day) {
  //   if (enabledDays.isEmpty) return true;
  //   return enabledDays
  //           .where(
  //             (element) =>
  //                 element.year == cYear &&
  //                 element.month == cMonth &&
  //                 element.day == day,
  //           )
  //           .length !=
  //       0;
  // }
  //
  // bool isDisabledDay(cYear, cMonth, int day) {
  //   return disabledDays
  //           .where(
  //             (element) =>
  //                 element.year == cYear &&
  //                 element.month == cMonth &&
  //                 element.day == day,
  //           )
  //           .length !=
  //       0;
  // }
}
