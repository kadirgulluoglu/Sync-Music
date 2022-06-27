import 'package:youtube_sync_music/screens/home_page.dart';
import 'package:flutter/material.dart';

import 'screens/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SyncYoutube',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: VideoScreen(id: "dZvTIw6EG_E"),
    );
  }
}
