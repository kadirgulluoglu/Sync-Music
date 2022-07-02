import 'dart:convert';
import 'dart:io';
import 'package:youtube_sync_music/models/video.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_sync_music/key.dart';

class APIService {
  APIService();

  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'youtube.googleapis.com';
  String _nextPageToken = '';

  Future<List<VideoModel>> fetchVideosFromPlaylist(String q) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': '8',
      //'order': 'viewCount',
      'q': 'Cem Yılmaz',
      'regionCode': 'bd',
      'safeSearch': 'moderate',
      'pageToken': _nextPageToken,
      'key': "AIzaSyCYJ3qYjFvtUHfl7ockRerW1h2S_Hdgf2A",
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';

      List<VideoModel> videos = [];

      videos = (data['items'] as List)
          .map(
            (i) => VideoModel.fromJson(i),
          )
          .toList();

      return videos;
    } else {
      print("Hata var gardaş");
      throw json.decode(response.body)['error']['message'];
    }
  }
}
