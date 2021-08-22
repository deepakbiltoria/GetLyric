import 'package:musicapp/components/parseTracks.dart';
import 'package:musicapp/services/apiCalls.dart';
import 'package:rxdart/rxdart.dart';

class TrackBloc {
  final _repository = ApiCalls();
  final _musicFetcher = PublishSubject<ParseTracks>();

  Stream<ParseTracks> get allMusic => _musicFetcher.stream;

  fetchAllMusic() async {
    ParseTracks itemModel = await _repository.fetchAllMusic();
    _musicFetcher.sink.add(itemModel);
  }

  dispose() {
    _musicFetcher.close();
  }
}

final bloc = TrackBloc();
