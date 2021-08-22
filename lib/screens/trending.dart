import 'package:flutter/material.dart';
import 'package:musicapp/blocService/trackBloc.dart';
import 'package:musicapp/blocService/trackDetailsDefiBloc.dart';
import 'package:musicapp/components/parseTracks.dart';
import 'package:musicapp/screens/trackDetails.dart';
import 'package:flutter_offline/flutter_offline.dart';

class TrendingTracks extends StatefulWidget {
  @override
  _TrendingTracksState createState() => _TrendingTracksState();
}

class _TrendingTracksState extends State<TrendingTracks> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMusic();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMusic();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Center(
            child: Text(
          'Trending',
          style: TextStyle(color: Colors.black),
        )),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return Center(
            child: connected
                ? startListing()
                : Text(
                    'No Internet Connection',
                  ),
          );
        },
        child: Container(),
      ),
    );
  }

  Widget startListing() {
    bloc.fetchAllMusic();
    return StreamBuilder(
      stream: bloc.allMusic,
      builder: (context, AsyncSnapshot<ParseTracks> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildList(AsyncSnapshot<ParseTracks> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            child: Container(
              margin: EdgeInsets.all(2.0),
              width: 320.0,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 10.0, color: Colors.blueGrey[200])),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      shape:
                          CircleBorder(side: BorderSide(color: Colors.white)),
                      child: Icon(
                        Icons.music_note_outlined,
                        color: Colors.black26,
                        size: 40.0,
                      ),
                    ),
                    flex: 2,
                  ),

                  Expanded(
                    child: ListTile(
                      title: Text(snapshot.data.results[index].track_name),
                      subtitle: Text(snapshot.data.results[index].album_name),
                    ),
                    flex: 7,
                  ),
                  Expanded(
                    child: ListTile(
                      trailing: Text(snapshot.data.results[index].artist_name),
                    ),
                    flex: 3,
                  )
//
                ],
              ),
//
            ),
            onTap: () => openDetailPage(snapshot.data, index),
          );
        });
  }

  openDetailPage(ParseTracks data, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TrackDetailDefiBloc(
          child: TrackDetails(
              artist_name: data.results[index].artist_name,
              track_name: data.results[index].track_name,
              album_name: data.results[index].album_name,
              explicit: data.results[index].explicit,
              track_rating: data.results[index].track_rating,
              track_id: data.results[index].track_id),
        );
      }),
    );
  }
}
