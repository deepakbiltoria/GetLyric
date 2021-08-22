import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:musicapp/components/parseLyrics.dart';
import 'package:musicapp/components/parseTracks.dart';
import 'dart:convert';

class ApiCallsDefinition {
  Client client = Client();

  Future<ParseTracks> fetchMusicList() async {
    print("entered");
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=53bfbfd7cb304daadd786aee244002e6"); //b9c5109c29515a0e2633d5916548f95a/
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ParseTracks.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<ParseLyrics> fetchLyrics(int track_id) async {
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$track_id&apikey=b9c5109c29515a0e2633d5916548f95a");

    if (response.statusCode == 200) {
      return ParseLyrics.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load trailers');
    }
  }
}
