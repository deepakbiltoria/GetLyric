import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicapp/blocService/trackDetailsDefiBloc.dart';
import 'package:musicapp/components/parseLyrics.dart';
import 'package:flutter_offline/flutter_offline.dart';

class TrackDetails extends StatefulWidget {
  final String artist_name;
  final String track_name;
  final String album_name;
  final String explicit;
  final String track_rating;
  final int track_id;

  TrackDetails(
      {this.artist_name,
      this.track_name,
      this.album_name,
      this.explicit,
      this.track_rating,
      this.track_id});

  @override
  State<StatefulWidget> createState() {
    return TrackDetailsState(
        artist_name: artist_name,
        track_name: track_name,
        album_name: album_name,
        explicit: explicit,
        track_rating: track_rating,
        track_id: track_id);
  }
}

class TrackDetailsState extends State<TrackDetails> {
  final String artist_name;
  final String track_name;
  final String album_name;
  final String explicit;
  final String track_rating;
  final int track_id;

  TrackDetailsBloc bloc;

  TrackDetailsState(
      {this.artist_name,
      this.track_name,
      this.album_name,
      this.explicit,
      this.track_rating,
      this.track_id});
  @override
  void didChangeDependencies() {
    bloc = TrackDetailDefiBloc.of(context);
    bloc.fetchTrailersById(track_id);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Track Details", style: TextStyle(color: Colors.black)),
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
                ? SafeArea(
                    child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('$track_name',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text(
                                'Artist',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('$artist_name',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text(
                                'Album Name',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('$album_name',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text(
                                'Explicit',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('$explicit', style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text(
                                'Rating',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('$track_rating',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text(
                                'Lyrics',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(top: 8.0, bottom: 8.0)),
                              StreamBuilder(
                                stream: bloc.movieTrailers,
                                builder: (context,
                                    AsyncSnapshot<Future<ParseLyrics>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    return FutureBuilder(
                                      future: snapshot.data,
                                      builder: (context,
                                          AsyncSnapshot<ParseLyrics>
                                              itemSnapShot) {
                                        if (itemSnapShot.hasData) {
                                          if (itemSnapShot.data.results.length >
                                              0)
                                            return trailerLayout(
                                                itemSnapShot.data);
                                          else
                                            return noTrailer(itemSnapShot.data);
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
                : Text(
                    'No Internet Connection',
                  ),
          );
        },
        child: Container(),
      ),
    );
  }
}

Widget noTrailer(ParseLyrics data) {
  return Center(
    child: Container(
      child: Text("No trailer available"),
    ),
  );
}

Widget trailerLayout(ParseLyrics data) {
  if (data.results.length > 1) {
    return Row(
      children: <Widget>[
        trailerItem(data, 0),
        trailerItem(data, 1),
      ],
    );
  } else {
    return Row(
      children: <Widget>[
        trailerItem(data, 0),
      ],
    );
  }
}

trailerItem(ParseLyrics data, int index) {
  return Expanded(
    child: Column(
      children: <Widget>[
        Text(data.results[index].lyrics_body, style: TextStyle(fontSize: 20)),
      ],
    ),
  );
}
