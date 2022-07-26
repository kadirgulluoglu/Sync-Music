import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController songname = TextEditingController();
  TextEditingController artistname = TextEditingController();

  late String imagepath, songpath;
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
      songpath = basename(song.path.toString());
      uploadsongfile(song.readAsBytesSync(), songpath);
    });
  }

  uploadsongfile(Uint8List song, String songpath) async {
    refenceyol = FirebaseStorage.instance.ref().child(songpath);
    UploadTask uploadTask = refenceyol.putData(song);
    uploadTask.whenComplete(() async {
      try {
        song_down_url = await refenceyol.getDownloadURL();
      } catch (onError) {
        print("Errors");
      }
      print(song_down_url);
    });
  }

  finalupload(context) {
    if (songname.text != '' && image_down_url != null) {
      print(songname.text);
      print(artistname.text);
      print(song_down_url);
      print(image_down_url.toString());
      var data = {
        "song_name": songname.text,
        "artist_name": artistname.text,
        "song_url": song_down_url.toString(),
        "image_url": image_down_url.toString(),
      };
      FirebaseFirestore.instance.collection("songs").doc().set(data);
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            _onTapButton(context, "Please Enter All Details :("),
      );
    }
  }

  _onTapButton(BuildContext context, data) {
    return AlertDialog(title: Text(data));
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
              child: Text(
                "Select Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => selectsong(),
              child: Text("Select Song"),
            ),
            TextField(
              controller: songname,
              decoration: InputDecoration(
                hintText: "Enter song name",
              ),
            ),
            TextField(
              controller: artistname,
              decoration: InputDecoration(
                hintText: "Enter artist name",
              ),
            ),
            ElevatedButton(
              onPressed: () => finalupload(context),
              child: Text("Upload"),
            ),
          ],
        )),
      ),
    );
  }
}
