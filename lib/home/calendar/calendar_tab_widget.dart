import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacasadeltonero/home/calendar/calendar_tab_controller.dart';
import 'package:table_calendar/table_calendar.dart';

import 'event_time.dart';

class CalendarTabWidget extends StatefulWidget {
  const CalendarTabWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarTabWidgetState();
}

class CalendarTabWidgetState extends State<CalendarTabWidget> {
  CalendarTabController controller = CalendarTabController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TableCalendar(
        eventLoader: (day) {
          return controller.filterEvent(day);
        },
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: controller.focusedDay,
        selectedDayPredicate: (day) {
          return true;
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            controller.setFocusedDay(selectedDay);
          });
        },
      ),
      Expanded(
        child: ValueListenableBuilder<List<EventItem>>(
          valueListenable: controller.eventsOfDay,
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
}
