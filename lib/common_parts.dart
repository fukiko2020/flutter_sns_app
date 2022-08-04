import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/providers/album.dart';
import 'package:flutter_sns_app/providers/common.dart';
import 'package:flutter_sns_app/providers/picture.dart';
import 'package:flutter_sns_app/providers/post.dart';
import 'package:flutter_sns_app/repositories/common.dart';
import 'package:flutter_sns_app/repositories/picture.dart';
import 'package:tuple/tuple.dart';

class FavoriteWidget extends ConsumerWidget {
  final int id;
  final String type; // 'post' or 'album' or 'picture'
  final bool isMyPage;

  const FavoriteWidget({
    super.key,
    required this.id,
    required this.type,
    this.isMyPage = false,
  });

  void _toggleFavorite(WidgetRef ref, Tuple2<String, int> itemInfo) async {
    ref.read(favoriteProvider(itemInfo)).setItemFavorite();

    // アルバムにいいね/解除でそのアルバムに属する写真もいいね/解除
    if (type == 'album') {
      final newFavorites = await getPictureList(albumId: id);
      for (final item in newFavorites) {
        setFavorite(
          'picture',
          item.id,
          isFavorite: ref
              .read(
                favoriteProvider(
                  itemInfo,
                ),
              )
              .isFavorite,
        );
      }
    }

    // マイページのお気に入り一覧からなら表示リストから削除
    if (isMyPage) {
      switch (type) {
        case 'post':
          ref.read(favoritePostsProvider).removeMyPageFavorite(id);
          break;
        case 'album':
          ref.read(favoriteAlbumsProvider).removeMyPageFavorite(id);
          break;
        case 'picture':
          ref.read(favoritePicturesProvider).removeMyPageFavorite(id);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemInfo = Tuple2<String, int>(type, id);
    final initialized = ref.watch(
      favoriteProvider(itemInfo).select((value) => value.initialized),
    );
    if (!initialized) {
      ref.read(favoriteProvider(itemInfo)).getItemFavorite();
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return IconButton(
      onPressed: () => _toggleFavorite(ref, itemInfo),
      icon: ref.watch(favoriteProvider(itemInfo)).isFavorite
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
        Navigator.of(context).pushNamed('/my_page');
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
