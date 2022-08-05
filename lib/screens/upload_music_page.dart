import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController songName = TextEditingController();
  TextEditingController artistName = TextEditingController();

  late String imagepath, songPath;
  late Reference refenceyol;
  var image_down_url, song_down_url;
  late PlatformFile imageresult, songresult;
  void selectimage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {
      imageresult = result!.files.first;
      File image = File(imageresult.path!);
      imagepath = basename(image.path.toString());
      uploadimagefile(image.readAsBytesSync(), imagepath);
    });
  }

  void uploadimagefile(Uint8List image, String imagepath) async {
    refenceyol = FirebaseStorage.instance.ref().child(imagepath);
    UploadTask uploadTask = refenceyol.putData(image);

    image_down_url = await (await uploadTask).ref.getDownloadURL();
  }

  void selectsong() async {
    final sresult = await FilePicker.platform.pickFiles(type: FileType.audio);
    setState(() {
      songresult = sresult!.files.first;
      File song = File(songresult.path!);
      songPath = basename(song.path.toString());
      uploadSongFile(song.readAsBytesSync(), songPath);
    });
  }

  uploadSongFile(Uint8List song, String songPath) async {
    refenceyol = FirebaseStorage.instance.ref().child(songPath);
    UploadTask uploadTask = refenceyol.putData(song);
    uploadTask.whenComplete(() async {
      try {
        song_down_url = refenceyol.getDownloadURL();
      } catch (onError) {
        const Text("Errors");
      }
    });
  }

  finalUpload(context) {
    if (true) {
      var data = {
        "song_name": songName.text,
        "artist_name": artistName.text,
        "song_url": song_down_url.toString(),
        "image_url": image_down_url.toString(),
      };
      FirebaseFirestore.instance.collection("songs").doc().set(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => selectimage(),
              child: const Text(
                "Select Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => selectsong(),
              child: const Text("Select Song"),
            ),
            TextField(
              controller: songName,
              decoration: const InputDecoration(
                hintText: "Enter song name",
              ),
            ),
            TextField(
              controller: artistName,
              decoration: const InputDecoration(
                hintText: "Enter artist name",
              ),
            ),
            ElevatedButton(
              onPressed: () => finalUpload(context),
              child: const Text("Upload"),
            ),
          ],
        )),
      ),
    );
  }
}
