import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
import 'package:flutter_event_calendar/src/models/calendar_options.dart';
import 'package:flutter_event_calendar/src/models/style/headers_options.dart';

class Day extends StatelessWidget {
  String weekDay;
  Function? onCalendarChanged;
  List<Event> dayEvents;
  int day;
  DayOptions? dayOptions;
  DayStyle? dayStyle;
  late double opacity;

  Day(
      {required this.day,
      required this.weekDay,
      required this.dayEvents,
      this.dayOptions,
      this.dayStyle,
      this.onCalendarChanged})
      : super() {
    dayOptions ??= DayOptions();
    dayStyle ??= DayStyle();
  }

  late Widget child;

  late Color textColor;

  @override
  Widget build(BuildContext context) {
    dayOptions = DayOptions.of(context);

    opacity = _shouldHaveTransparentColor() ? 0.5 : 1;

    textColor = dayStyle!.selected
        ? dayOptions!.selectedTextColor
        : dayOptions!.unselectedTextColor;

    child = InkWell(
      onTap: (() {
        if (dayStyle!.enabled) onCalendarChanged?.call();
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!dayStyle!.mini)
            FittedBox(
              child: Text(
                '$weekDay',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _getTitleColor(),
                  fontFamily: CalendarOptions.of(context).font,
                ),
              ),
            ),
          if (!dayStyle!.mini)
            SizedBox(
              height: 8,
            ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
            padding: dayStyle!.mini
                ? EdgeInsets.all(0)
                : (EdgeInsets.all(HeaderOptions.of(context).weekDayStringType ==
                        WeekDayStringTypes.FULL
                    ? 4
                    : 0)),
            decoration: BoxDecoration(
                color: dayStyle!.selected
                    ? dayOptions!.selectedBackgroundColor
                    : dayOptions!.unselectedBackgroundColor,
                shape: BoxShape.circle),
            constraints: BoxConstraints(
                minWidth: double.infinity, minHeight: dayStyle!.mini ? 35 : 45),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: textColor,
                      fontFamily: CalendarOptions.of(context).font,
                    ),
                  ),
                ),
                Align(
                  alignment: dayOptions!.eventCounterViewType ==
                          DayEventCounterViewType.DOT
                      ? Alignment.bottomCenter
                      : Alignment.bottomRight,
                  child: dayOptions!.eventCounterViewType ==
                          DayEventCounterViewType.DOT
                      ? dotMaker(context)
                      : labelMaker(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // }
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: EdgeInsets.all(dayStyle!.mini ? 0 : 10),
        decoration: dayStyle?.decoration,
        width: dayStyle!.mini
            ? 45
            : (HeaderOptions.of(context).weekDayStringType ==
                    WeekDayStringTypes.FULL
                ? 80
                : 60),
        child: child,
      ),
    );
  }

  dotMaker(BuildContext context) {
    List<Widget> widgets = [];

    final maxDot = min(dayEvents.length, 3);
    for (int i = 0; i < maxDot; i++) {
      widgets.add(
        Container(
          margin: EdgeInsets.only(
              bottom: HeaderOptions.of(context).weekDayStringType ==
                      WeekDayStringTypes.SHORT
                  ? (dayStyle!.mini ? 4 : 8)
                  : 2),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dayOptions!.eventCounterColor,
          ),
        ),
      );
      if (i != maxDot - 1)
        widgets.add(
          SizedBox(
            width: 2,
          ),
        );
    }
    return Row(mainAxisSize: MainAxisSize.min, children: widgets);
  }

  labelMaker(BuildContext context) {
    if (dayEvents.isEmpty) return Container();
    return Container(
      margin: EdgeInsets.only(right: 2),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dayOptions!.eventCounterColor,
      ),
      child: Text(
        "${dayEvents.length >= 10 ? '+9' : dayEvents.length}",
        style: TextStyle(
            fontSize: 10,
            fontFamily: CalendarOptions.of(context).font,
            color: dayStyle!.useUnselectedEffect
                ? dayOptions!.eventCounterTextColor
                : dayOptions!.eventCounterTextColor),
      ),
    );
  }

  _getTitleColor() {
    return dayStyle!.selected
        ? dayOptions!.weekDaySelectedColor
        : (dayStyle?.decoration?.color ?? dayOptions!.weekDayUnselectedColor);
  }

  _shouldHaveTransparentColor() {
    return dayStyle!.useUnselectedEffect || !dayStyle!.enabled;
  }
}

class DayStyle {
  final bool mini;
  final bool useUnselectedEffect;
  final bool enabled;
  final bool selected;
  final BoxDecoration? decoration;

  const DayStyle(
      {this.mini = false,
      this.useUnselectedEffect = false,
      this.enabled = false,
      this.selected = false,
      this.decoration = const BoxDecoration()});
}
