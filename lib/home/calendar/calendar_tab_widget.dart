import 'package:flutter/material.dart';
import 'package:lacasadeltonero/home/calendar/calendar_tab_controller.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../util/ui_status.dart';
import 'calendar_item.dart';

class CalendarTabWidget extends StatefulWidget {
  const CalendarTabWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarTabWidgetState();
}

class CalendarTabWidgetState extends State<CalendarTabWidget> {
  CalendarTabController controller = CalendarTabController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.getUiStatus(),
        builder: (content, snapshoot) {
          if (snapshoot.hasData) {
            switch (snapshoot.data.runtimeType) {
              case UiLoading:
                return const CircularProgressIndicator();
              case UiListing<CalendarItem>:
                List<CalendarItem> events =
                    (snapshoot.data as UiListing<CalendarItem>).list;
                return Column(children: [
                  TableCalendar(
                    eventLoader: (day) {
                      return controller.filterEvent(day, events);
                    },
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: controller.focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(day, controller.focusedDay);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        controller.setFocusedDay(selectedDay, events);
                      });
                    },
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<CalendarItem>>(
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
                                onTap: () =>
                                    print('${value[index].description}'),
                                title: Text('${value[index].description}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ]);
              default:
                return const Text("unkonw error");
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
