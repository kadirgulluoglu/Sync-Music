import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  VideoScreen({required this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      params: YoutubePlayerParams(
        showControls: false,
        useHybridComposition: true,
        showVideoAnnotations: false,
        showFullscreenButton: false,
        desktopMode: true,
        playsInline: true,
        strictRelatedVideos: false,
        mute: false,
        autoPlay: true,
        enableCaption: false,
      ),
    );
    _controller?.hideTopMenu();
    _controller?.hidePauseOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          YoutubeValueBuilder(
            controller: _controller,
            builder: (context, value) {
              return IconButton(
                icon: Icon(
                  value.playerState == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                onPressed: value.isReady
                    ? () {
                        value.playerState == PlayerState.playing
                            ? _controller?.pause()
                            : _controller?.play();
                      }
                    : null,
              );
            },
          ),
          YoutubePlayerIFrame(
            controller: _controller!,
            aspectRatio: 4 / 6,
          ),
        ],
      ),
    );
  }
}
