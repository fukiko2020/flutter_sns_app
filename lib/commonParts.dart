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
    Future(() async {
      final favoriteData = await getFavorite(widget.type, widget.id);
      setState(
        () {
          isFavorite = favoriteData;
        },
      );
    });
  }

  // 写真・アルバム・投稿：マイページからお気に入り削除されたらマイページから削除
  // アルバムからお気に入りされたらアルバム内のすべての写真をお気に入り追加かつsetState
  // マイページからのお気に入り削除でなければsetState

  // マイページからのお気に入り削除はまだアルバムにしか対応できていない
  void _toggleFavorite() async {
    setFavorite(widget.type, widget.id, isFavorite);
    // マイページからお気に入り削除されたら実行
    // マイページからお気に入り追加はできないから追加or削除の条件分岐は不要
    if (widget.type == 'album') {
      final newFavorites = await getPictureList(albumIndex: widget.id);
      for (final item in newFavorites) {
        setFavorite('picture', item.id, isFavorite);
      }
      if (widget.isMyPage) {
        print('remove ${widget.id}');
        ref.read(favoriteAlbumsProvider).removeMyPageFavorite(widget.id);
      }
    }

    if (!widget.isMyPage) {
      setState(
        () {
          isFavorite = !isFavorite;
        },
      );
    }
    // if (widget.isMyPage && widget.type == 'album') {
    //   print('remove ${widget.id}');
    //   ref.read(favoriteAlbumsProvider).removeMyPageFavorite(widget.id);
    // }
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
