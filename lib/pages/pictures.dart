import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/common_parts.dart';
import 'package:flutter_sns_app/models/picture.dart';
import 'package:flutter_sns_app/providers.dart';
import 'package:flutter_sns_app/repository.dart';

class PicturesPage extends ConsumerWidget {
  const PicturesPage({Key? key}) : super(key: key);

  // ボトムナビゲーションバーのアクティブタブをアルバムに戻す
  Future<bool> changeActiveTab(WidgetRef ref) {
    ref.read(currentTabProvider.state).update((state) => state = 1);
    return Future.value(true); // onWillPop の戻り値はFuture<bool>
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dynamic albumIndex = ModalRoute.of(context)!.settings.arguments;
    return WillPopScope(
      onWillPop: () => changeActiveTab(ref),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('写真'),
          // アルバムをクリックして遷移してきたなら戻るボタンあり、ボトムバー空の遷移なら戻るボタン無し
          automaticallyImplyLeading: albumIndex == null ? false : true,
        ),
        body: FutureBuilder<List<Picture>>(
          future: albumIndex == null
              ? getPictureList()
              : getPictureList(albumIndex: albumIndex as int),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PicturesWidget(pictureList: snapshot.data!);
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
      ),
    );
  }
}

// 写真一覧とマイページのお気に入り投稿一覧で使用
class PicturesWidget extends ConsumerWidget {
  final List<Picture> pictureList;
  final bool isMyPage;
  const PicturesWidget({
    super.key,
    required this.pictureList,
    this.isMyPage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ), // カラム数
      itemCount: pictureList.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final picture = pictureList[index];
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(2),
              child: Image.network(picture.thumbnailUrl),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: FavoriteWidget(
                id: picture.id,
                type: 'picture',
                isMyPage: isMyPage,
              ),
            ),
          ],
        );
      },
    );
  }
}
