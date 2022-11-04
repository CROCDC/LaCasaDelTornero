abstract class CalendarItem {
  static const String eventType = "EVENT";
  static const String weeklyType = "WEEKLY";
  final String description;

  CalendarItem(this.description);
}

class EventCalendarItem extends CalendarItem {
  final DateTime time;

  EventCalendarItem(String description, this.time) : super(description);
}

class WeeklyCalendarItem extends CalendarItem {
  final int day;

  WeeklyCalendarItem(String description, this.day) : super(description);
}
