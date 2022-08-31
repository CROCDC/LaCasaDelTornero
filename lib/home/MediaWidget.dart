import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaWidget extends StatefulWidget {
  const MediaWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MediaWidgetState();
}

class MediaWidgetState extends State<MediaWidget> {
  final List<Media> images = <Media>[
    MediaVideo("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
    MediaVideo("https://drive.google.com/uc?id=1XLRiUXon0bb2fC4obC_mYZOxRZAXEV8Q"),
    MediaVideo("https://drive.google.com/uc?id=1pEGDcXg3YS0DmWFlzDzaA0WJlChBlcY5"),
    MediaImage(
        "https://instagram.faep24-1.fna.fbcdn.net/v/t51.2885-15/300696523_5257339430981076_4318806334883484679_n.webp?stp=dst-jpg_e35&_nc_ht=instagram.faep24-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=6QR_1QTw_Q0AX-WRIwx&tn=bviaWeM8ipsQN_Lq&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MjkxMDYyODY3NTg2ODgzNDExOQ%3D%3D.2-ccb7-5&oh=00_AT9-zv2RcQE6M_dk14C0lx93BeCNPg0S93J4riQ9C-nINw&oe=63157AD7&_nc_sid=30a2ef"),
    MediaVideo("https://drive.google.com/uc?id=1jSt9hPrq6LClS6iSV5b_YYQQ1g2t3h7n"),
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

class MediaItem extends StatelessWidget {
  final Media media;

  const MediaItem({Key? key, required this.media}) : super(key: key);

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
    return VideoPlayerScreen(
      url: url,
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({super.key, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
   _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(children: [
          AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller)),
          Positioned.fill(
              child: GestureDetector(
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            onTap: () => {_controller.play()},
          ))
        ]));
  }
}
