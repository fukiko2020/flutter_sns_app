import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sns_app/providers.dart';

class FavoriteWidget extends ConsumerStatefulWidget {
  final int index;
  final String type; // 'post' or 'album' or 'picture'
  const FavoriteWidget({super.key, required this.index, required this.type});

  @override
  ConsumerState<FavoriteWidget> createState() => FavoriteWidgetState();
}

class FavoriteWidgetState extends ConsumerState<FavoriteWidget> {
  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final favoriteData = await getFavorite(widget.type, widget.index);
      setState(
        () {
          isFavorite = favoriteData;
        },
      );
    });
    // print('initialized favorite state ${widget.type}${widget.index}');
  }

  void _toggleFavorite() {
    setFavorite(widget.type, widget.index, isFavorite);
    setState(
      () {
        isFavorite = !isFavorite;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleFavorite,
      icon: isFavorite
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
      color: Colors.pink,
    );
  }
}

class MyBottomNavigationBar extends ConsumerWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  void toOtherPages(int index, BuildContext context, WidgetRef ref) {
    ref.read(currentTabProvider.state).update((state) => index);
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/');
        break;
      case 1:
        Navigator.of(context).pushNamed('/albums');
        break;
      case 2:
        Navigator.of(context).pushNamed('/pictures', arguments: null);
        break;
      case 3:
        Navigator.of(context).pushNamed('/my-page');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.speaker_notes),
          label: '投稿',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections),
          label: 'アルバム',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: '写真',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'ホーム',
        ),
      ],
      onTap: (index) => toOtherPages(index, context, ref),
      currentIndex: ref.watch(currentTabProvider),
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black54,
    );
  }
}
