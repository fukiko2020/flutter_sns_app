import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/pages/albums.dart';
import 'package:flutter_sns_app/pages/change_name.dart';
import 'package:flutter_sns_app/pages/mypage.dart';
import 'package:flutter_sns_app/pages/pictures.dart';
import 'package:flutter_sns_app/pages/posts.dart';
import 'package:flutter_sns_app/pages/settings.dart';
import 'package:flutter_sns_app/providers.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MySnsApp(),
    ),
  );
}

class MySnsApp extends ConsumerStatefulWidget {
  const MySnsApp({Key? key}) : super(key: key);

  @override
  MySnsAppState createState() => MySnsAppState();
}

class MySnsAppState extends ConsumerState<MySnsApp> {
  @override
  void initState() {
    ref.read(isDarkModeProvider).getIsDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider).isDarkMode;
    // return isDarkMode.when(
    // data: (isDarkMode) {
    return MaterialApp(
      title: 'Flutter SNS App',
      // theme: ThemeData.light(),
      theme: isDarkMode
      ? ThemeData.light()
      : ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const PostsPage(),
        '/albums': (context) => const AlbumsPage(),
        '/pictures': (context) => const PicturesPage(),
        '/my-page': (context) => const MyPage(),
        '/my-page/settings': (context) => const SettingsPage(),
        '/my-page/settings/change-username': (context) =>
            const ChangeNamePage(),
      },
    );
    // },
    // error: (err, stack) => Text('Error: $err'),
    // loading: () => const CircularProgressIndicator(),
    // );
  }
}
