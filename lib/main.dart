import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/pages/albums.dart';
import 'package:flutter_sns_app/pages/pictures.dart';
import 'package:flutter_sns_app/pages/posts.dart';


void main() {
  runApp(
    const ProviderScope(
      child: MySnsApp(),
    ),
  );
}

class MySnsApp extends StatelessWidget {
  const MySnsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SNS App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PostsPage(),
        '/albums': (context) => const AlbumsPage(),
        '/pictures': (context) => const PicturesPage(),
        // '/my-page': (context) => const MyPage(),
        // '/my-page/settings': (context) => const SettingsPage(),
      },
    );
  }
}
