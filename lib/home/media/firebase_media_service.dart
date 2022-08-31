import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'media.dart';

class FirebaseMediaService {
  Future<List<Media>> fetchMedia() async {
    Future<List<Media>> result = Future.value(List.empty());

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('media').get();

    final data = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<Media> mediaList = List.empty(growable: true);
    for (var element in data) {
      element = (element as LinkedHashMap<String, dynamic>);
      mediaList.add(Media(element["type"], element["url"]));
    }
    result = Future.value(mediaList);
    return result;
  }
}
