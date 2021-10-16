import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/models/calendar_options.dart';
import 'package:flutter_event_calendar/src/models/event.dart';
import 'package:flutter_event_calendar/src/models/style/headers_options.dart';
import 'package:flutter_event_calendar/src/models/style/event_options.dart';
import 'package:flutter_event_calendar/src/providers/calendars/calendar_provider.dart';
import 'package:flutter_event_calendar/src/providers/instance_provider.dart';
import 'package:flutter_event_calendar/src/utils/calendar_types.dart';
import 'package:flutter_event_calendar/src/widgets/calendar_daily.dart';
import 'package:flutter_event_calendar/src/widgets/calendar_monthly.dart';
import 'package:flutter_event_calendar/src/widgets/events.dart';
import 'package:flutter_event_calendar/src/widgets/header.dart';
import 'package:scoped_model/scoped_model.dart';

typedef CalendarChangeCallback = Function(CalendarDateTime);

class EventCalendar extends StatefulWidget {
  static late CalendarProvider calendarProvider;
  static late CalendarDateTime dateTime;
  static late List<Event> events;
  static List<Event> selectedEvents = [];

  // static late HeaderMonthStringTypes headerMonthStringType;
  // static late HeaderWeekDayStringTypes headerWeekDayStringType;
  static late String calendarLanguage;
  static late CalendarType calendarType;

  CalendarChangeCallback? onChangeDateTime;

  List<CalendarDateTime> specialDays;

  CalendarOptions? calendarOptions;

  DayOptions? dayStyle;

  EventOptions? eventStyle;

  HeaderOptions? headerStyle;

  Widget? Function(CalendarDateTime)? middleWidget;

  EventCalendar(
      {List<Event>? events,
      CalendarDateTime? dateTime,
      this.middleWidget,
      this.calendarOptions,
      this.dayStyle,
      this.eventStyle,
      this.headerStyle,
      this.specialDays = const [],
      this.onChangeDateTime,
      required calendarType,
      calendarLanguage}) {
    calendarProvider = createInstance(calendarType);

    this.calendarOptions ??= CalendarOptions();
    this.headerStyle ??= HeaderOptions();
    this.eventStyle ??= EventOptions();
    this.dayStyle ??= DayOptions();

    EventCalendar.events = events ?? [];
    EventCalendar.dateTime = dateTime ?? calendarProvider.getDateTime();
    EventCalendar.calendarType = calendarType ?? CalendarType.GREGORIAN;
    EventCalendar.calendarLanguage = calendarLanguage ?? 'fa';
  }

  @override
  _EventCalendarState createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: buildScopeModels(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Header(
                onHeaderChanged: () {
                  widget.onChangeDateTime?.call(EventCalendar.dateTime);
                  setState(() {});
                },
              ),
              isMonthlyView()
                  ? CalendarMonthly(
                      specialDays: widget.specialDays,
                      onCalendarChanged: () {
                        widget.onChangeDateTime?.call(EventCalendar.dateTime);
                        setState(() {});
                      })
                  : CalendarDaily(
                      specialDays: widget.specialDays,
                      onCalendarChanged: () {
                        widget.onChangeDateTime?.call(EventCalendar.dateTime);
                        setState(() {});
                      }),
              if (widget.middleWidget != null)
                widget.middleWidget!.call(EventCalendar.dateTime)!,
              Events(onEventsChanged: () {
                setState(() {});
              }),
            ],
          ),
        ),
      ),
    );
  }

  isMonthlyView() {
    return widget.calendarOptions?.viewType == ViewType.MONTHLY;
  }

  buildScopeModels({required Container child}) {
    return ScopedModel<CalendarOptions>(
      model: widget.calendarOptions!,
      child: ScopedModel<DayOptions>(
        model: widget.dayStyle!,
        child: ScopedModel<EventOptions>(
          model: widget.eventStyle!,
          child: ScopedModel<HeaderOptions>(
            model: widget.headerStyle!,
            child: child,
          ),
        ),
      ),
    );
  }
}
