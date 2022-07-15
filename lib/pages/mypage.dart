import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/commonParts.dart';
import 'package:flutter_sns_app/pages/albums.dart';
import 'package:flutter_sns_app/pages/pictures.dart';
import 'package:flutter_sns_app/pages/posts.dart';
import 'package:flutter_sns_app/providers.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyPage> createState() => MyPageState();
}

class MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    ref.read(favoritePostsProvider).getFavoritePostList();
    ref.read(favoriteAlbumsProvider).getFavoriteAlbumList();
    ref.read(favoritePicturesProvider).getFavoritePictureList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  Navigator.of(context).pushNamed('/my-page/settings'),
              icon: const Icon(Icons.settings),
              iconSize: 28,
            ),
          ],
          title: Consumer(
            builder: (context, ref, child) =>
                Text('${ref.watch(usernameProvider.state)}のお気に入り'),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.speaker_notes,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.collections,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.image,
                  color: Colors.black,
                ),
              ),
            ],
          ),
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
