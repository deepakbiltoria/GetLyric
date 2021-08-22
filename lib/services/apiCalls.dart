import 'dart:async';
import 'package:musicapp/components/parseLyrics.dart';
import 'package:musicapp/components/parseTracks.dart';
import 'package:musicapp/services/apiCallsDefinition.dart';

class ApiCalls {
  final musicApiProvider = ApiCallsDefinition();

  Future<ParseTracks> fetchAllMusic() => musicApiProvider.fetchMusicList();
  Future<ParseLyrics> fetchLyrics(int track_id) => musicApiProvider.fetchLyrics(track_id);
}
