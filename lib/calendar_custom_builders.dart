import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_custom_parts.dart';

class CustomCalendarBuilders {
  StartingDayOfWeek startDow;
  CustomCalendarBuilders(this.startDow);

  Widget allDayBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
    [bool selected = false]
  ) {
    final Border border = borderOfDay(context, day, startDow, focusedDay);
    final Text text = Text(
      day.day.toString(),
      style: TextStyle(
        color: customizedColor(
          target: 'text', selected: selected, day: day, focusedDay: focusedDay
        ),
      ),
    );
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: border,
        color: customizedColor(
          target: 'cell', selected: selected, day: day, focusedDay: focusedDay
        ),
      ),
      alignment: Alignment.topCenter,
      child: text,
    );
  }

  Widget selectedBuilder(
    BuildContext context, DateTime day, DateTime focusedDay
  ) {
    return allDayBuilder(context, day, focusedDay, true);
  }

  Widget dowBuilder(
    BuildContext context, DateTime day
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final dowText = DateFormat.E(locale).format(day);
    return Container(
      decoration: BoxDecoration(
        border: borderOfDay(context, day, startDow),
      ),
      child: Center(
        child: Text(
          dowText,
          style: TextStyle(
            color: dowColor(target: 'text', day: day),
          ),
        ),
      ),
    );
  }

  Widget markerBuilder(
    BuildContext context, DateTime day, List<dynamic> eventsForDay,
  ) {
    if (eventsForDay.isEmpty) return const Text('');
    int eventCount = eventsForDay.length;
    return Padding(
      padding: const EdgeInsets.only(top: markerTopInset),
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: DottedDecoration(
          linePosition: LinePosition.top,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$eventCount件'),
            Text('☺️' * eventCount),
          ],
        ),
      ),
    );
  }
}
