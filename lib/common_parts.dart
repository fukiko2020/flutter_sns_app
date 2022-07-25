import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/providers.dart';
import 'package:flutter_sns_app/repository.dart';

class FavoriteWidget extends ConsumerStatefulWidget {
  final int id;
  final String type; // 'post' or 'album' or 'picture'
  final bool isMyPage;
  const FavoriteWidget({
    super.key,
    required this.id,
    required this.type,
    this.isMyPage = false,
  });

  @override
  ConsumerState<FavoriteWidget> createState() => FavoriteWidgetState();
}

class FavoriteWidgetState extends ConsumerState<FavoriteWidget> {
  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        final favoriteData = await getFavorite(widget.type, widget.id);
        setState(
          () {
            isFavorite = favoriteData;
          },
        );
      },
    );
  }

  void _toggleFavorite() async {
    setFavorite(widget.type, widget.id, isFavorite: isFavorite);

    // アルバムにいいね/解除でそのアルバムに属する写真もいいね/解除
    if (widget.type == 'album') {
      final newFavorites = await getPictureList(albumIndex: widget.id);
      for (final item in newFavorites) {
        setFavorite('picture', item.id, isFavorite: isFavorite);
      }
    }

    // マイページのお気に入り一覧からなら表示リストから削除
    if (widget.isMyPage) {
      switch (widget.type) {
        case 'post':
          ref.read(favoritePostsProvider).removeMyPageFavorite(widget.id);
          break;
        case 'album':
          ref.read(favoriteAlbumsProvider).removeMyPageFavorite(widget.id);
          break;
        case 'picture':
          ref.read(favoritePicturesProvider).removeMyPageFavorite(widget.id);
          break;
      }
    } else {
      // 投稿一覧/アルバム一覧/写真一覧ページからならステートを変更
      setState(
        () {
          isFavorite = !isFavorite;
        },
      );
    }
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
        Navigator.of(context).pushNamed('/pictures');
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
      selectedItemColor: Colors.blue,
      unselectedItemColor: ref.watch(isDarkModeProvider).isDarkMode
          ? Colors.white
          : Colors.black38,
    );
  }
}
