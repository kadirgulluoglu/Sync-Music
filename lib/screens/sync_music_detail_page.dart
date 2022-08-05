import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'dart:async';

class SyncMusicDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final String img;
  final String songUrl;
  final Duration currentPosition;

  const SyncMusicDetailPage(
      {Key? key,
      required this.title,
      required this.description,
      required this.color,
      required this.img,
      required this.songUrl,
      required this.currentPosition})
      : super(key: key);
  @override
  _SyncMusicDetailPageState createState() => _SyncMusicDetailPageState();
}

class _SyncMusicDetailPageState extends State<SyncMusicDetailPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  bool isPlaying = true;
  bool syncMusic = false;
  late Timer _timer;
  String title = "";
  int audioState = 1;
  Duration pos = const Duration();
  Duration duration = const Duration(seconds: 594);
  Duration position = const Duration();

  void playMusic(String url) async {
    audioPlayer.play(url);
    pos = widget.currentPosition;
    _timer = Timer.periodic(const Duration(microseconds: 1), (timer) {
      setState(() {
        title = "${DateTime.now().millisecond}";
      });
    });
    audioPlayer.setReleaseMode(ReleaseMode.STOP);

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  // convert format time
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      audioPlayerState = s;
    });
    playMusic(widget.songUrl);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (audioState == 1 && audioPlayerState == AudioPlayerState.PLAYING) {
      int timer = int.parse(title);
      timer = timer + 2600;
      Duration currentPosition = Duration(milliseconds: timer);
      currentPosition += widget.currentPosition;
      audioPlayer.seek(currentPosition);
      _timer.cancel();
      audioState = 0;
    }

    return Scaffold(
      backgroundColor: black,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  getAppBar() {
    return AppBar(
      backgroundColor: black,
      elevation: 0,
      actions: const [
        IconButton(
            icon: Icon(
              Icons.more_vert_sharp,
              color: white,
            ),
            onPressed: null)
      ],
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: size.width - 100,
                  height: size.width - 100,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: widget.color,
                        blurRadius: 50,
                        spreadRadius: 5,
                        offset: const Offset(-10, 40))
                  ], borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: size.width - 60,
                  height: size.width - 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.img), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              width: size.width - 80,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.my_library_add,
                    color: white,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 18,
                            color: white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          widget.description,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, color: white.withOpacity(0.5)),
                        ),
                      )
                    ],
                  ),
                  const Icon(
                    Icons.more_vert_sharp,
                    color: white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Slider(
            activeColor: primary,
            value: position.inSeconds.toDouble(),
            max: duration.inSeconds.toDouble(),
            min: 0.0,
            onChanged: (double value) {},
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTime(position),
                  style: TextStyle(color: white.withOpacity(0.5)),
                ),
                Text(
                  formatTime(duration - position),
                  style: TextStyle(color: white.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.shuffle,
                      color: white.withOpacity(0.8),
                      size: 25,
                    ),
                    onPressed: null),
                IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: white.withOpacity(0.8),
                      size: 25,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 50,
                    icon: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: primary),
                      child: Center(
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 28,
                          color: white,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await audioPlayer.resume();
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    }),
                IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: white.withOpacity(0.8),
                      size: 25,
                    ),
                    onPressed: null),
                IconButton(
                    icon: Icon(
                      Icons.cached,
                      color: white.withOpacity(0.8),
                      size: 25,
                    ),
                    onPressed: null)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
