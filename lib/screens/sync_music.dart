import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_sync_music/screens/sync_music_player.dart';
import 'package:youtube_sync_music/theme/colors.dart';

class syncMusic extends StatefulWidget {
  const syncMusic({Key? key}) : super(key: key);

  @override
  State<syncMusic> createState() => _syncMusicState();
}

class _syncMusicState extends State<syncMusic> {
  TextEditingController syncController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginSync(),
    );
  }

  loginSync() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            maxLength: 6,
            enableIMEPersonalizedLearning: false,
            keyboardType: TextInputType.number,
            controller: syncController,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 1)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 3)),
                labelText: 'Sync Kodu',
                labelStyle: TextStyle(color: primary)),
            textInputAction: TextInputAction.done,
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: SyncMusicPlayer(docId: syncController.text),
                      type: PageTransitionType.scale));
            },
            child: Text(
              "Eşitle",
              style: TextStyle(color: primary),
            ),
          )
        ],
      ),
    );
  }
}
