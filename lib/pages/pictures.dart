import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/common_parts.dart';
import 'package:flutter_sns_app/models/picture.dart';
import 'package:flutter_sns_app/providers/common.dart';
import 'package:flutter_sns_app/providers/picture.dart';

class PicturesPage extends ConsumerWidget {
  const PicturesPage({Key? key}) : super(key: key);

  // ボトムナビゲーションバーのアクティブタブをアルバムに戻す
  Future<bool> changeActiveTab(WidgetRef ref) {
    ref.read(currentTabProvider.state).update((state) => state = 1);
    return Future.value(true); // onWillPop の戻り値はFuture<bool>
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // albumId を取得（渡していなければ null になる）
    dynamic albumId = ModalRoute.of(context)!.settings.arguments;
    // プロバイダで監視
    final pictureList = ref.watch(pictureListProvider(albumId));
    return WillPopScope(
      onWillPop: () => changeActiveTab(ref),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('写真'),
          // アルバムをクリックして遷移してきたなら戻るボタンあり、ボトムバー空の遷移なら戻るボタン無し
          automaticallyImplyLeading: albumId == null ? false : true,
        ),
        // 1. when メソッドを使用
        body: pictureList.when(
          data: (data) => PicturesWidget(pictureList: data),
          error: (err, stack) => Text('Error: $err'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }
}

// 写真一覧とマイページのお気に入り写真一覧で使用するため、PicturesPage から切り分けて定義
class PicturesWidget extends ConsumerWidget {
  final List<Picture> pictureList; // 表示する写真データを親ウィジェットから受け取る
  final bool isMyPage;
  const PicturesWidget({
    super.key,
    required this.pictureList,
    this.isMyPage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // GridView を使用してマス目状の UI を作る
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ), // カラム数
      itemCount: pictureList.length, // 要素数
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final picture = pictureList[index];
        // itemBuilder の戻り値でウィジェットを返す
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
