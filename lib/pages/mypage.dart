import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/common_parts.dart';
import 'package:flutter_sns_app/pages/albums.dart';
import 'package:flutter_sns_app/pages/pictures.dart';
import 'package:flutter_sns_app/pages/posts.dart';
import 'package:flutter_sns_app/providers/album.dart';
import 'package:flutter_sns_app/providers/picture.dart';
import 'package:flutter_sns_app/providers/post.dart';
import 'package:flutter_sns_app/providers/user.dart';
import 'package:flutter_sns_app/repositories/user.dart';

class MyPage extends ConsumerWidget {
  const MyPage({Key? key}) : super(key: key);

  void init(WidgetRef ref) {
    ref.read(favoritePostsProvider).getFavoritePostList();
    ref.read(favoriteAlbumsProvider).getFavoriteAlbumList();
    ref.read(favoritePicturesProvider).getFavoritePictureList();
    Future(
      () async {
        final username = await getUsername();
        ref.read(usernameProvider.state).update(
              (state) => state = username,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    init(ref);
    final postListProvider = ref.watch(favoritePostsProvider);
    final albumListProvider = ref.watch(favoriteAlbumsProvider);
    final pictureListProvider = ref.watch(favoritePicturesProvider);
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/my_page/settings'),
              icon: const Icon(Icons.settings),
              iconSize: 28,
            ),
          ],
          title: Consumer(
            builder: (context, ref, child) =>
                Text('${ref.watch(usernameProvider)}のお気に入り'),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.speaker_notes,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.collections,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.image,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: TabBarView(
          children: [
            PostsWidget(
              postList: postListProvider.favoriteList,
              isMyPage: true,
            ),
            AlbumsWidget(
              albumList: albumListProvider.favoriteList,
              isMyPage: true,
            ),
            PicturesWidget(
              pictureList: pictureListProvider.favoriteList,
              isMyPage: true,
            ),
          ],
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }
}
