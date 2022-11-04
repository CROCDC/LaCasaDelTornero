import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacasadeltonero/home/calendar/firebase_calendar_service.dart';

import '../../util/ui_status.dart';
import 'calendar_item.dart';

class CalendarTabController {
  DateTime focusedDay = DateTime.now();

  final ValueNotifier<List<CalendarItem>> eventsOfDay = ValueNotifier([]);

  FirebaseCalendarService service = FirebaseCalendarService();

  void setFocusedDay(DateTime selectedDay, List<CalendarItem> events) async {
    focusedDay = selectedDay;
    eventsOfDay.value = filterEvent(selectedDay, events);
  }

  List<CalendarItem> filterEvent(
      DateTime selectedDay, List<CalendarItem> events) {
    List<CalendarItem> eventsOfDay = <CalendarItem>[];
    for (var element in events) {
      switch (element.runtimeType) {
        case EventCalendarItem:
          EventCalendarItem item = element as EventCalendarItem;
          if (DateUtils.isSameDay(selectedDay, item.time)) {
            eventsOfDay.add(item);
          }
          break;

        case WeeklyCalendarItem:
          WeeklyCalendarItem item = element as WeeklyCalendarItem;
          if (selectedDay.weekday == item.day) {
            eventsOfDay.add(item);
          }
          break;
      }
    }
    return eventsOfDay;
  }

  Future<UiStatus> getUiStatus() async {
    Future<UiStatus> future = Future.value(UiLoading());
    try {
      future = Future.value(UiListing(await service.fetchCalendar()));
    } catch (e) {
      future = Future.value(UiError());
    }
    return future;
  }
}
