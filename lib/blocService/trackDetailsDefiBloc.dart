import 'package:flutter/material.dart';
import 'trackDetailsBloc.dart';
export 'trackDetailsBloc.dart';

class TrackDetailDefiBloc extends InheritedWidget {
  final TrackDetailsBloc bloc;

  TrackDetailDefiBloc({Key key, Widget child})
      : bloc = TrackDetailsBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static TrackDetailsBloc of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<TrackDetailDefiBloc>())
        .bloc;
  }
}
