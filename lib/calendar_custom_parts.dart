import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

const double markerTopInset = 22;

const Color lightGrey = Colors.black26;

final Map<String, Map<String, Color>> customizedColors = {
  'normal': {
    'cell': Colors.transparent,
    'text': Colors.black,
  },
  'Saturday': {
    'cell': Colors.transparent,
    'text': Colors.blueAccent,
  },
  'Sunday': {
    'cell': Colors.transparent,
    'text': Colors.redAccent,
  },
  'notThisMonth': {
    'cell': Colors.transparent,
    'text': lightGrey,
  },
  'selected': {
    'cell': Colors.blueGrey,
    'text': Colors.white,
  },
  'today': {
    'cell': lightGrey,
    'text': Colors.white,
  },
};

Color customizedColor({
  String? target, bool? selected, DateTime? day, DateTime? focusedDay
}) {
  const Color unexpected = Colors.transparent;
  if (day == null || focusedDay == null) return unexpected;
  final bool notThisMonth =
    day.year != focusedDay.year || day.month != focusedDay.month;
  Map? tmp;
  if (selected == true) {
    tmp = customizedColors['selected'];
  } else if (dayIsToday(day)) {
    tmp = customizedColors['today'];
  } else if (notThisMonth) {
    tmp = customizedColors['notThisMonth'];
  } else if (dayIsSaturday(day)) {
    tmp = customizedColors['Saturday'];
  } else if (dayIsSunday(day)) {
    tmp = customizedColors['Sunday'];
  } else {
    tmp = customizedColors['normal'];
  }
  return (tmp ?? {})[target] ?? unexpected;
}

Color dowColor({ String? target, DateTime? day }) {
  const Color unexpected = Colors.transparent;
  if (day == null) return unexpected;
  Map? tmp;
  if (dayIsSaturday(day)) {
    tmp = customizedColors['Saturday'];
  } else if (dayIsSunday(day)) {
    tmp = customizedColors['Sunday'];
  } else {
    tmp = customizedColors['normal'];
  }
  return (tmp ?? {})[target] ?? unexpected;
}

bool dayIsSaturday(DateTime day) {
  return day.weekday == 6;
}

bool dayIsSunday(DateTime day) {
  return day.weekday == 7;
}

bool dayIsToday(DateTime day) {
  final DateTime now = DateTime.now();
  // table_calendarのdayがYYYY-MM-DD 00:00:00.000Zなのでオフセット足して比較
  final dayWithOffset = day.add(now.timeZoneOffset);
  return isSameDay(now, dayWithOffset);
}

bool inCalendarLastRow(
  DateTime day, DateTime focusedDay, StartingDayOfWeek startDow
) {
  final int yearMonthDiff =
    (day.year * 100 + day.month) - (focusedDay.year * 100 + focusedDay.month);
  final bool inCurrentMonth = yearMonthDiff == 0;
  final bool inNextMonth = yearMonthDiff > 0;
  final DateTime lastDayOfMonth = DateTime.utc(day.year, day.month + 1, 0);
    // dayがUTCなので合わせた
  final int startDowIndex = startDow.index + 1; // Mon=1..Sun=7
  final int currentWeekday = day.weekday
    + (day.weekday < startDowIndex ? 7 : 0); // 週先頭を最小化
  final int lastWeekday = lastDayOfMonth.weekday
    + (lastDayOfMonth.weekday < startDowIndex ? 7 : 0); // S.A.A.
  return inNextMonth || (
    inCurrentMonth
      && day.add(const Duration(days: 7)).month != day.month
      && currentWeekday <= lastWeekday
  );
}

Border borderOfDay(
  BuildContext context,
  DateTime day,
  StartingDayOfWeek startDow,
  [DateTime? focusedDay]
) {
  final bool lastOfWeek = day.weekday % 7 == startDow.index % 7;
  final bool atLastRow = focusedDay != null &&
    inCalendarLastRow(day, focusedDay, startDow);
  final Color commonColor = Theme.of(context).colorScheme.secondary;
  final BorderSide border = BorderSide(
    color: commonColor,
  );
  final BorderSide rightBorder = BorderSide(
    color: lastOfWeek ? commonColor : Colors.transparent,
  );
  final BorderSide bottomBorder = BorderSide(
    color: atLastRow ? commonColor : Colors.transparent,
  );
  return Border(
    top: border,
    left: border,
    right: rightBorder,
    bottom: bottomBorder,
  );
}
