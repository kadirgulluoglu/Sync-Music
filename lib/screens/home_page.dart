import 'package:youtube_sync_music/models/video.dart';
import 'package:flutter/material.dart';
import 'package:youtube_sync_music/screens/video_player.dart';

import 'package:youtube_sync_music/services/api_services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoModel>? _videoModel;
  bool _isLoading = false;
  TextEditingController? searchcontroller = TextEditingController();
  String search = "Kadir";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                cursorColor: Colors.grey.shade900,
                maxLines: 1,
                onChanged: (text) {
                  setState(() {
                    search = searchcontroller!.text;
                  });
                },
                controller: searchcontroller,
                decoration: InputDecoration(
                  hintText: "Video Ara",
                  hintStyle: TextStyle(color: Theme.of(context).focusColor),
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  fillColor: Colors.indigo,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black45)),
                ),
              ),
              SizedBox(height: size.height * .4),
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollDetails) {
                  if (!_isLoading &&
                      scrollDetails.metrics.pixels ==
                          scrollDetails.metrics.maxScrollExtent) {
                    setState(() {
                      _getMoreVideos();
                    });
                  }
                  return false;
                },
                child: _getVideos(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder _getVideos() {
    return FutureBuilder(
      future: APIService().fetchVideosFromPlaylist(search),
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
        await APIService.instance.fetchVideosFromPlaylist(search);
    List<VideoModel> allVideos = _videoModel!..addAll(moreVideos);
    setState(() {
      print(search + "sa");
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
