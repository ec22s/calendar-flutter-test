import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:table_calendar/table_calendar.dart';

class CalendarModel extends ChangeNotifier {
  DateTime get firstDay => DateTime(2021, 1, 1);
  DateTime get lastDay => DateTime(2030, 12, 31);

  final String eventsCountsJsonUri = 'data/example.json';
  // パスにハイフン・アンダースコアがあると読み込まれない

  DateTime now = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay; //DateTime.now();
  LinkedHashMap<DateTime, List> events = LinkedHashMap<DateTime, List>();

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<LinkedHashMap<DateTime, List>> fetchEvents() async {
    String loadData = await rootBundle.loadString(eventsCountsJsonUri);
    final eventMap = <DateTime, List>{};
    for (final Map<String, dynamic> obj in json.decode(loadData)) {
      final String? date = obj['date'];
      if (date != null) {
        DateTime localDateTime = DateTime.parse(date); // ローカルタイムになる
        eventMap[localDateTime] = obj['events'];
      }
    }
    return LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventMap);
  }

  Future<void> init() async {
    events = await fetchEvents();
    notifyListeners(); // 最初の読み込み完了後にカレンダーを更新する用
  }

  void selectYear(int? year) {
    if (year == null) return;
    focusedDay = DateTime.utc(year, focusedDay.month, 1);
    notifyListeners();
  }

  void selectYearMonth(day) {
    focusedDay = DateTime.utc(day.year, day.month, 1);
    notifyListeners();
  }

  void selectMonth(int? month) {
    if (month == null) return;
    focusedDay = DateTime.utc(focusedDay.year, month, 1);
    notifyListeners();
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay = selectedDay;
    notifyListeners();

    List eventList = events[selectedDay] ?? [];
    if (eventList.isEmpty) return;
    // 必要なら日選択後の処理を追加
  }

  List<dynamic> fetchEventsForDay(DateTime dateTime) {
    // ローカルタイムに変換して検索
    return events[dateTime.toLocal()] ?? [];
  }
}
