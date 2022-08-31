import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lacasadeltonero/home/calendar/event_time.dart';

class FirebaseCalendarService {
  Future<List<EventItem>> fetchCalendar() async {
    Future<List<EventItem>> result = Future.value(List.empty());

    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('calendar').get();

    final data = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<EventItem> mediaList = List.empty(growable: true);
    for (var element in data) {
      element = (element as LinkedHashMap<String, dynamic>);
      Timestamp timestamp = element["day"];
      mediaList.add(EventItem(element["description"], timestamp.toDate()));
    }
    result = Future.value(mediaList);
    return result;
  }
}
