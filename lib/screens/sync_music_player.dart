import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        body: Center(
      child: Column(
        children: [
          Text(widget.docId),
          SizedBox(height: 60),
          FutureBuilder<DocumentSnapshot>(
            future: sync.doc(widget.docId.toString()).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                print(data);
              }
              print("loading");
              return Text("Loading");
            },
          ),
        ],
      ),
    ));
  }
}
