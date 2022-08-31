import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTabWidget extends StatefulWidget {
  const CalendarTabWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarTabWidgetState();
}

class CalendarTabWidgetState extends State<CalendarTabWidget> {
  DateTime _focusedDay = DateTime.now();
  final ValueNotifier<List<EventItem>> showEvents = ValueNotifier([]);
  List<EventItem> events = <EventItem>[
    EventItem("Clase semanal 4 a 7PM", DateTime(2022, 8, 31)),
    EventItem("Encuentro de torneros", DateTime(2022, 11, 19)),
    EventItem("Encuentro de torneros", DateTime(2022, 11, 20))
  ];


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TableCalendar(
        eventLoader: (day) {
          return _getEventsForDay(day);
        },
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_focusedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _focusedDay = selectedDay;
            showEvents.value = _getEventsForDay(selectedDay);
          });
        },
      ),
      Expanded(
        child: ValueListenableBuilder<List<EventItem>>(
          valueListenable: showEvents,
          builder: (context, value, _) {
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    onTap: () => print('${value[index].description}'),
                    title: Text('${value[index].description}'),
                  ),
                );
              },
            );
          },
        ),
      )
    ]);
  }

  List<EventItem> _getEventsForDay(DateTime day) {
    List<EventItem> eventsForDay = <EventItem>[];
    for (var element in events) {
      if (isSameDay(element.day, day)) {
        eventsForDay.add(element);
      }
    }
    return eventsForDay;
  }
}

class EventItem {
  final String description;
  final DateTime day;

  EventItem(this.description, this.day);

  @override
  String toString() {
    return description;
  }
}
