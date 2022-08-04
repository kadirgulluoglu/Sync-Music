import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_sync_music/screens/music_detail_page.dart';
import 'package:youtube_sync_music/theme/colors.dart';

import 'sync_music_detail_page.dart';

class SyncMusicPlayer extends StatefulWidget {
  final String docId;
  const SyncMusicPlayer({Key? key, required this.docId}) : super(key: key);

  @override
  State<SyncMusicPlayer> createState() => _SyncMusicPlayerState();
}

class _SyncMusicPlayerState extends State<SyncMusicPlayer> {
  CollectionReference sync = FirebaseFirestore.instance.collection('sync');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
      future: sync.doc(widget.docId.toString()).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          print("Something went wrong");
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          print("Document does not exist");
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          Duration currentPosition =
              Duration(milliseconds: data['currentPosition']);
          return SyncMusicDetailPage(
              currentPosition: currentPosition,
              title: data['musicName'],
              description: data['artistName'],
              color: Colors.red,
              img: data['imgUrl'],
              songUrl: data['songUrl']);
        }
        return Scaffold(
          backgroundColor: black,
          body: const Center(child: CircularProgressIndicator(color: primary)),
        );
      },
    ));
  }
}
