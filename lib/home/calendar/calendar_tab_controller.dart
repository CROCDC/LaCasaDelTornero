import 'package:flutter/cupertino.dart';
import 'package:lacasadeltonero/home/calendar/firebase_calendar_service.dart';

import 'event_time.dart';

class CalendarTabController {
  DateTime focusedDay = DateTime.now();

  final ValueNotifier<List<EventItem>> eventsOfDay = ValueNotifier([]);

  FirebaseCalendarService service = FirebaseCalendarService();

  Future<List<EventItem>> events = FirebaseCalendarService().fetchCalendar();

  void setFocusedDay(DateTime selectedDay) async {
    focusedDay = selectedDay;
    eventsOfDay.value = filterEvent(selectedDay);
  }

  List<EventItem> filterEvent(DateTime selectedDay) {
    List<EventItem> eventsOfDay = <EventItem>[];
    events.then((value) => {
          for (var element in value)
            {
              if (element.time.day == selectedDay.day &&
                  element.time.month == selectedDay.month)
                {eventsOfDay.add(element)}
            }
        });
    return eventsOfDay;
  }
}
