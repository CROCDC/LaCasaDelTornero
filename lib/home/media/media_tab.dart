import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../util/ui_status.dart';
import 'media_tab_controller.dart';

class MediaTabWidget extends StatefulWidget {
  const MediaTabWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MediaTabWidgetState();
}

class MediaTabWidgetState extends State<MediaTabWidget> {
  @override
  Widget build(BuildContext context) {
    MediaTabController controller = MediaTabController();
    return FutureBuilder(
        future: controller.getUiStatus(),
        builder: (content, snapshoot) {
          if (snapshoot.hasData) {
            switch (snapshoot.data.runtimeType) {
              case UiLoading:
                return const CircularProgressIndicator();
              case UiListing<MediaWidget>:
                UiListing uiListing = snapshoot.data as UiListing<MediaWidget>;
                return ListView.builder(
                    itemCount: uiListing.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return uiListing.list[index].getWidget();
                    });
              default:
                return const Text("unkonw error");
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class MediaListWidget extends StatelessWidget {
  final MediaWidget media;

  const MediaListWidget({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return media.getWidget();
  }
}

abstract class MediaWidget {
  final String url;

  MediaWidget(this.url);

  Widget getWidget();
}

class MediaImage extends MediaWidget {
  MediaImage(super.url);

  @override
  Widget getWidget() {
    return Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10),
        elevation: 20,
        child: Image.network(url, fit: BoxFit.fill));
  }
}

class MediaVideo extends MediaWidget {
  MediaVideo(super.url);

  @override
  Widget getWidget() {
    return MediaVideoItem(
      url: url,
    );
  }
}

class MediaVideoItem extends StatefulWidget {
  final String url;

  const MediaVideoItem({super.key, required this.url});

  @override
  _MediaVideoItemState createState() => _MediaVideoItemState();
}

class _MediaVideoItemState extends State<MediaVideoItem> {
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;
  late Future<void> _future;

  Future<void> initVideoPlayer() async {
    await videoPlayerController.initialize();
    setState(() {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: true,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url);
    _future = initVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return Center(
            child: videoPlayerController.value.isInitialized
                ? Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 20,
                    margin: const EdgeInsets.all(10.0),
                    child: AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: Chewie(
                        controller: chewieController,
                      ),
                    ))
                : const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: CircularProgressIndicator()),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
  }
}
