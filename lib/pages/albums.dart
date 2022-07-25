import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/common_parts.dart';
import 'package:flutter_sns_app/models/album.dart';
import 'package:flutter_sns_app/providers.dart';
import 'package:flutter_sns_app/repository.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アルバム'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Album>>(
        future: getAlbumList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AlbumsWidget(albumList: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}

// アルバム一覧とマイページのお気に入り投稿一覧で使用
class AlbumsWidget extends StatelessWidget {
  final List<Album> albumList;
  final bool isMyPage;
  const AlbumsWidget({
    super.key,
    required this.albumList,
    this.isMyPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ), // カラム数
      itemCount: albumList.length,
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final album = albumList[index];
        return AlbumWidget(id: album.id, album: album, isMyPage: isMyPage);
        // }
      },
    );
  }
}

class AlbumWidget extends ConsumerStatefulWidget {
  final int id;
  final Album album;
  final bool isMyPage;

  const AlbumWidget({
    super.key,
    required this.id,
    required this.album,
    this.isMyPage = false,
  });

  @override
  ConsumerState<AlbumWidget> createState() => AlbumWidgetState();
}

class AlbumWidgetState extends ConsumerState<AlbumWidget> {
  String backImgUrl = '';

  @override
  void initState() {
    super.initState();
    Future(() async {
      final backImg = await getPictureList(albumIndex: widget.id);
      setState(
        () {
          backImgUrl = backImg[0].thumbnailUrl;
        },
      );
    });
  }

  void toPicturesPage(int albumIndex, BuildContext context, WidgetRef ref) {
    ref.read(currentTabProvider.state).update((state) => 2); // タブをpictures にする
    Navigator.of(context).pushNamed(
      '/pictures',
      arguments: albumIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userList = ref.watch(userListProvider);
    return GestureDetector(
      onTap: () => toPicturesPage(widget.id, context, ref),
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 20, right: 8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(backImgUrl),
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.6),
              BlendMode.dstATop,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: userList.when(
            data: (data) => [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          data[widget.album.userId].name,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '@${data[widget.album.userId].username}',
                        ),
                      ),
                    ],
                  ),
                  FavoriteWidget(
                    id: widget.id,
                    type: 'album',
                    isMyPage: widget.isMyPage,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  widget.album.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            error: (err, stack) => [
              Text('Error: $err'),
            ],
            loading: () => [
              const Text('loading user info...'),
            ],
          ),
        ),
      ),
    );
  }
}
