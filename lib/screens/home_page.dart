import 'package:youtube_sync_music/models/video.dart';
import 'package:flutter/material.dart';
import 'package:youtube_sync_music/screens/video_player.dart';

import 'package:youtube_sync_music/services/api_services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoModel>? _videoModel;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails) {
          if (!_isLoading &&
              scrollDetails.metrics.pixels ==
                  scrollDetails.metrics.maxScrollExtent) {
            _getMoreVideos();
          }
          return false;
        },
        child: _getVideos(),
      ),
    );
  }

  FutureBuilder _getVideos() {
    return FutureBuilder(
      future: APIService().fetchVideosFromPlaylist(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _videoModel = snapshot.data;
          return _buildBody(_videoModel);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _getMoreVideos() async {
    List<VideoModel> moreVideos =
        await APIService.instance.fetchVideosFromPlaylist();
    List<VideoModel> allVideos = _videoModel!..addAll(moreVideos);
    setState(() {
      _videoModel = allVideos;
    });
  }

  _buildBody(List<VideoModel>? videoModel) {
    return ListView.builder(
      itemCount: _videoModel!.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoScreen(id: _videoModel![index].id.videoId),
            ),
          ),
          child: Row(
            children: [
              Container(
                child: Image.network(videoModel![index]
                    .snippet
                    .thumbnails
                    .thumbnailsDefault
                    .url),
              ),
              Text(videoModel[index].snippet.title),
            ],
          ),
        );
      },
    );
  }
}
