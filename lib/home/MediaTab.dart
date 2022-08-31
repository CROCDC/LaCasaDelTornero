import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaTabWidget extends StatefulWidget {
  const MediaTabWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MediaTabWidgetState();
}

class MediaTabWidgetState extends State<MediaTabWidget> {
  final List<Media> images = <Media>[
    MediaVideo(
        "https://firebasestorage.googleapis.com/v0/b/silver-octo-carnival.appspot.com/o/Jugando%20un%20ratito%20en%20La%20casa%20del%20tornero.mp4?alt=media&token=3afd6dc1-61a2-493f-8560-f7e831ac0258"),
    MediaVideo(
        "https://firebasestorage.googleapis.com/v0/b/silver-octo-carnival.appspot.com/o/Una%20tarde%20preparando%20material%20en%20La%20casa%20del%20tornero.mp4?alt=media&token=8df268b8-7d14-4fd9-aae3-cf87790bbca5"),
    MediaImage(
        "https://instagram.faep24-1.fna.fbcdn.net/v/t51.2885-15/300696523_5257339430981076_4318806334883484679_n.webp?stp=dst-jpg_e35&_nc_ht=instagram.faep24-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=6QR_1QTw_Q0AX-WRIwx&tn=bviaWeM8ipsQN_Lq&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MjkxMDYyODY3NTg2ODgzNDExOQ%3D%3D.2-ccb7-5&oh=00_AT9-zv2RcQE6M_dk14C0lx93BeCNPg0S93J4riQ9C-nINw&oe=63157AD7&_nc_sid=30a2ef"),
    MediaVideo(
        "https://firebasestorage.googleapis.com/v0/b/silver-octo-carnival.appspot.com/o/Seminario%20de%20Agosto.%20GrupoIICua%CC%81nta%20gente%20linda%20conocimos%20hoy%2C%20un%20gustazo!.mp4?alt=media&token=ecfccfff-45dd-4516-97e7-7e7f93fc6103"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return images[index].getWidget();
        });
  }
}

class MediaListWidget extends StatelessWidget {
  final Media media;

  const MediaListWidget({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return media.getWidget();
  }
}

abstract class Media {
  Widget getWidget();
}

class MediaImage extends Media {
  final String url;

  MediaImage(this.url);

  @override
  Widget getWidget() {
    return Padding(
        padding: const EdgeInsets.all(10.0), child: Image.network(url));
  }
}

class MediaVideo extends Media {
  final String url;

  MediaVideo(this.url);

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
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
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
