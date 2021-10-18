import 'package:flutter/material.dart';

class CalendarDateTime {
  int year;
  int month;
  int day;
  int? toMonth;
  int? toDay;
  int? hour;
  int? minute;
  int? second;
  bool isEnableDay;
  Color? color;

  CalendarDateTime(
      {required this.year,
      required this.month,
      required this.day,
      this.isEnableDay = true,
      this.toMonth,
      this.toDay,
      this.hour,
      this.minute,
      this.second,
      this.color});

  //supported format 1400-9-12 20:00(:50)
  static CalendarDateTime? parse(String dateTime) {
    final splitter = dateTime.split(" ");
    final datePart = splitter[0].split("-");
    final timePart = splitter[1].split(":");

    try {
      return CalendarDateTime(
        year: int.parse(datePart[0]),
        month: int.parse(datePart[1]),
        day: int.parse(datePart[2]),
        hour: int.parse(timePart[0]),
        minute: int.parse(timePart[1]),
        second: timePart.length == 3 ? double.parse(timePart[2]).toInt() : 0,
      );
    } on Exception catch (e) {
      print("${e.toString()}");
      return null;
    }
  }

  bool isDateEqual(CalendarDateTime dateTime) {
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day;
  }

  bool isDateEqualByInt(int year, int month, int day) {
    return this.year == year && this.month == month && this.day == day;
  }

  bool isDateTimeEqual(CalendarDateTime dateTime) {
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour &&
        minute == dateTime.minute;
  }

  @override
  String toString() {
    if (hour != null && minute != null) {
      return "$year/$month/$day $hour:$minute${second != null ? ':$second' : ''}";
    } else
      return "$year/$month/$day";
  }
}
