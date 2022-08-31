import 'package:lacasadeltonero/home/media/firebase_media_service.dart';

import '../../util/ui_status.dart';
import 'media.dart';
import 'media_tab.dart';

class MediaTabController {
  final FirebaseMediaService service = FirebaseMediaService();

  Future<UiStatus> getUiStatus() async {
    Future<UiStatus> future = Future.value(UiLoading());
    try {
      List<Media> mediaList = await service.fetchMedia();
      List<MediaWidget> widgets = List.empty(growable: true);
      for (var element in mediaList) {
        switch (element.type) {
          case Media.imageType:
            widgets.add(MediaImage(element.url));
            break;
          case Media.videoType:
            widgets.add(MediaVideo(element.url));
            break;
        }
      }
      future = Future.value(UiListing(widgets));
    } catch (e) {
      future = Future.value(UiError());
    }

    return future;
  }
}
