import 'package:custom_table_calendar/calendar_model.dart';
import 'package:custom_table_calendar/custom_calendar_builders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarModel>(
      create: (_) => CalendarModel()..init(),
      child: Consumer<CalendarModel>(builder: (context, model, snapshot) {
        final CustomCalendarBuilders customCalendarBuilders =
            CustomCalendarBuilders();

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: TableCalendar<dynamic>(
                availableCalendarFormats: {
                  CalendarFormat.month: "Month",
                },
                focusedDay: model.focusedDay,
                firstDay: model.firstDayOfMonth,
                lastDay: model.lastDayOfMonth,
                locale: Localizations.localeOf(context).languageCode,
                // markerBuilderの大きさに合わせて調整してください
                rowHeight: 70,
                // 曜日文字の大きさに合わせて調整してください
                // 日本語だとこのくらいで見切れなくなります
                daysOfWeekHeight: 32,
                // 見た目をスッキリさせるためなのでなくても大丈夫です
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  // formatButtonVisible: false,
                  // leftChevronVisible: false,
                  // rightChevronVisible: false,
                ),
                calendarStyle: const CalendarStyle(
                  // true（デフォルト）の場合は
                  // todayBuilderが呼ばれるので設定しましょう
                  isTodayHighlighted: false,
                ),
                // カスタマイズ用の関数を渡してやりましょう
                calendarBuilders: CalendarBuilders(
                  dowBuilder: customCalendarBuilders.daysOfWeekBuilder,
                  defaultBuilder: customCalendarBuilders.defaultBuilder,
                  disabledBuilder: customCalendarBuilders.disabledBuilder,
                  selectedBuilder: customCalendarBuilders.selectedBuilder,
                  markerBuilder: customCalendarBuilders.markerBuilder,
                  headerTitleBuilder: (_, day) {
                    final DateFormat dateFormat = DateFormat('yyyy年M月');
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(dateFormat.format(model.focusedDay)),
                        TextButton(
                          onPressed: () {
                            model.selectDay(DateTime.now(), DateTime.now());
                          },
                          child: const Text('今月を表示')
                        ),
                        // TODO: 年選択・月選択を追加
                      ]
                    );
                  }
                ),
                eventLoader: model.fetchScheduleForDay,
                selectedDayPredicate: (day) {
                  return isSameDay(model.selectedDay, day);
                },
                // TODO: 日のタップイベントを追加する
                // onDaySelected: (selectedDay, focusedDay) {
                //   model.selectDay(selectedDay, focusedDay);
                // },
                onPageChanged: (focusedDay) {
                  model.focusedDay = focusedDay;
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
