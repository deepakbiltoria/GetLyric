import 'package:flutter/material.dart';
import 'package:musicapp/screens/trending.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Trending',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[50],
          primaryColor: Colors.deepOrangeAccent,
        ),
        home: TrendingTracks());
  }
}
