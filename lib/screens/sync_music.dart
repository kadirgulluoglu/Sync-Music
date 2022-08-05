import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_sync_music/screens/sync_music_player.dart';
import 'package:youtube_sync_music/theme/colors.dart';

class SyncMusic extends StatefulWidget {
  const SyncMusic({Key? key}) : super(key: key);

  @override
  State<SyncMusic> createState() => _SyncMusicState();
}

class _SyncMusicState extends State<SyncMusic> {
  TextEditingController syncController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
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
          Image.asset("assets/images/logo.png"),
          TextField(
            style: const TextStyle(color: Colors.white),
            maxLength: 6,
            enableIMEPersonalizedLearning: false,
            keyboardType: TextInputType.number,
            controller: syncController,
            decoration: const InputDecoration(
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
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: SyncMusicPlayer(docId: syncController.text),
                      type: PageTransitionType.scale));
            },
            child: const Text(
              "Eşitle",
              style: TextStyle(color: primary),
            ),
          )
        ],
      ),
    );
  }
}
