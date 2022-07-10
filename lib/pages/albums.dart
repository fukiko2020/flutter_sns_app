import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/commonParts.dart';
import 'package:flutter_sns_app/models/album.dart';
import 'package:flutter_sns_app/providers.dart';
import 'package:flutter_sns_app/repository.dart';

class AlbumsPage extends ConsumerWidget {
  const AlbumsPage({Key? key}) : super(key: key);

  void toPicturesPage(int albumIndex, BuildContext context, WidgetRef ref) {
    ref.read(currentTabProvider.state).update((state) => 2); // タブをpictures にする
    Navigator.of(context).pushNamed(
      '/pictures',
      arguments: albumIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userList = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('アルバム'),
      ),
      body: FutureBuilder<List<Album>>(
        future: getAlbumList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ), // カラム数
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final album = snapshot.data![index];
                return GestureDetector(
                  onTap: () => toPicturesPage(index, context, ref),
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.only(left: 8, top: 20, right: 8),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://via.placeholder.com/600/24f355'),
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
                                      data[album.userId].name,
                                      // style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '@${data[album.userId].username}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              FavoriteWidget(index: index, type: 'album'),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              album.title,
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
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
