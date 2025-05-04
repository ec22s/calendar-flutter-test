import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_custom_builders.dart';
import 'calendar_custom_parts.dart';
import 'calendar_model.dart';

const EdgeInsets paddingPage = EdgeInsets.fromLTRB(16, 8, 16, 16);
const EdgeInsets paddingGoThisMonth = EdgeInsets.symmetric(vertical: 9, horizontal: 16);
const EdgeInsets paddingHeader = EdgeInsets.symmetric(vertical: 8, horizontal: 0);
const double dowHeight = 32;
final dropdownDecoration = InputDecorationTheme(
  isDense: true,
  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
  border: const OutlineInputBorder(
    borderSide: BorderSide(color: lightGrey), // 反映されない. 要調査 [TODO]
  )
);

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarModel>(
      create: (_) => CalendarModel()..init(),
      child: Consumer<CalendarModel>(builder: (context, model, _) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: paddingPage,
                child: tableCalendar(context, model),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

TableCalendar tableCalendar(BuildContext context, CalendarModel model) {
  const startDow = StartingDayOfWeek.sunday;
  final CalendarBuilders builders = calendarBuilders(context, model, startDow);
  return TableCalendar(
    availableCalendarFormats: const {
      CalendarFormat.month: 'Month',
    },
    calendarBuilders: builders,
    calendarStyle: const CalendarStyle(
      isTodayHighlighted: false,
    ),
    eventLoader: model.fetchEventsForDay,
    focusedDay: model.focusedDay,
    firstDay: model.firstDay,
    lastDay: model.lastDay,
    locale: Localizations.localeOf(context).languageCode,
    daysOfWeekHeight: dowHeight,
    onDaySelected: (selectedDay, focusedDay) =>
      model.selectDay(selectedDay, focusedDay),
    onPageChanged: (focusedDay) => model.focusedDay = focusedDay,
    selectedDayPredicate: (day) => isSameDay(model.selectedDay, day),
    shouldFillViewport: true,
    startingDayOfWeek: startDow,
  );
}

CalendarBuilders calendarBuilders(
  BuildContext context, CalendarModel model, StartingDayOfWeek startDow
) {
  final CustomCalendarBuilders builders = CustomCalendarBuilders(startDow);
  return CalendarBuilders(
    dowBuilder: builders.dowBuilder,
    defaultBuilder: builders.allDayBuilder,
    disabledBuilder: builders.allDayBuilder,
    headerTitleBuilder: headerTitleBuilder(model),
    outsideBuilder: builders.allDayBuilder,
    markerBuilder: builders.markerBuilder,
    selectedBuilder: builders.selectedBuilder,
    // todayBuilder は発火しないので不使用. 要調査 [TODO]
  );
}

DayBuilder headerTitleBuilder(CalendarModel model) {
  return (context, day) => Container(
    // decoration: BoxDecoration(
    //   color: lightGrey,
    // ),
    padding: paddingHeader,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        yearDropdown(model),
        monthDropdown(model),
        goThisMonth(model),
      ],
    ),
  );
}

DropdownMenu<int> yearDropdown(CalendarModel model) {
  final int yearFirst = model.firstDay.year;
  final int yearLast = model.lastDay.year;
  final TextEditingController yearController = TextEditingController();
  yearController.value = TextEditingValue(text: model.focusedDay.year.toString());
  return DropdownMenu<int>(
    controller: yearController,
    dropdownMenuEntries: List.generate(
      yearLast - yearFirst + 1,
      (int i) {
        int y = i + yearFirst;
        return DropdownMenuEntry(value: y, label: '$y');
      },
    ),
    enableSearch: false,
    initialSelection: DateTime.now().year,
  	inputDecorationTheme: dropdownDecoration,
    label: const Text('年'),
    onSelected: (int? val) => model.selectYear(val),
    requestFocusOnTap: true,
    textAlign: TextAlign.center,
  );
}

DropdownMenu<int> monthDropdown(CalendarModel model) {
  final TextEditingController monthController = TextEditingController();
  monthController.value = TextEditingValue(text: model.focusedDay.month.toString());
  return DropdownMenu<int>(
    controller: monthController,
    dropdownMenuEntries: List.generate(
      12,
      (int i) {
        int m = i + 1;
        return DropdownMenuEntry(value: m, label: '$m');
      },
    ),
    enableSearch: false,
    initialSelection: DateTime.now().year,
  	inputDecorationTheme: dropdownDecoration,
    label: const Text('月'),
    onSelected: (int? val) => model.selectMonth(val),
    requestFocusOnTap: true,
    textAlign: TextAlign.center,
  );
}

TextButton goThisMonth(CalendarModel model) {
  return TextButton(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: lightGrey,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: paddingGoThisMonth,
      child: const Text('今月'),
    ),
    onPressed: () => model.selectYearMonth(DateTime.now()),
  );
}
