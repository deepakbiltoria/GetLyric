import 'dart:async';

import 'package:musicapp/components/parseLyrics.dart';
import 'package:musicapp/services/apiCalls.dart';
import 'package:rxdart/rxdart.dart';

class TrackDetailsBloc {
  final _repository = ApiCalls();
  final _trackId = PublishSubject<int>();
  final _lyrics = BehaviorSubject<Future<ParseLyrics>>();

  Function(int) get fetchTrailersById => _trackId.sink.add;
  Stream<Future<ParseLyrics>> get movieTrailers => _lyrics.stream;

  TrackDetailsBloc() {
    _trackId.stream.transform(_itemTransformer()).pipe(_lyrics);
  }

  dispose() async {
    _trackId.close();
    await _lyrics.drain();
    _lyrics.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Future<ParseLyrics> trailer, int id, int index) {
        print(index);
        trailer = _repository.fetchLyrics(id);
        return trailer;
      },
    );
  }
}
