import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lacasadeltonero/home/calendar/calendar_item.dart';

class FirebaseCalendarService {
  Future<List<CalendarItem>> fetchCalendar() async {
    Future<List<CalendarItem>> result = Future.value(List.empty());

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('calendar').get();

    final data = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<CalendarItem> calendarItems = List.empty(growable: true);
    for (var element in data) {
      element = (element as LinkedHashMap<String, dynamic>);
      String type = element["type"];
      switch (type) {
        case CalendarItem.eventType:
          Timestamp timestamp = element["day"];
          calendarItems.add(
              EventCalendarItem(element["description"], timestamp.toDate()));
          break;
        case CalendarItem.weeklyType:
          int day = int.parse(element["day"]);
          calendarItems.add(WeeklyCalendarItem(element["description"], day));
          break;
      }
    }
    result = Future.value(calendarItems);
    return result;
  }
}
