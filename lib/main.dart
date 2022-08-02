import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/pages/albums.dart';
import 'package:flutter_sns_app/pages/change_name.dart';
import 'package:flutter_sns_app/pages/mypage.dart';
import 'package:flutter_sns_app/pages/pictures.dart';
import 'package:flutter_sns_app/pages/posts.dart';
import 'package:flutter_sns_app/pages/settings.dart';
import 'package:flutter_sns_app/providers/common.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MySnsApp(),
    ),
  );
}

class MySnsApp extends ConsumerWidget {
  const MySnsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(isDarkModeProvider).getIsDarkMode;
    final isDarkMode = ref.watch(isDarkModeProvider).isDarkMode;
    return MaterialApp(
      title: 'Flutter SNS App',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const PostsPage(),
        '/albums': (context) => const AlbumsPage(),
        '/pictures': (context) => const PicturesPage(),
        '/my_page': (context) => MyPage(),
        '/my_page/settings': (context) => const SettingsPage(),
        '/my_page/settings/change_username': (context) =>
            ChangeNamePage(),
      },
    );
  }
}
