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
    return MaterialApp(
      title: 'Flutter SNS App',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const PostsPage(),
        '/albums': (context) => const AlbumsPage(),
        '/pictures': (context) => const PicturesPage(),
        '/my_page': (context) => const MyPage(),
        '/my_page/settings': (context) => const SettingsPage(),
        '/my_page/settings/change_username': (context) =>
            const ChangeNamePage(),
      },
    );
  }
}
