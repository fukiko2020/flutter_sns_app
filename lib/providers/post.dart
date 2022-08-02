import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/models/post.dart';
import 'package:flutter_sns_app/repositories/common.dart';
import 'package:flutter_sns_app/repositories/post.dart';

final postListProvider = FutureProvider<List<Post>>(
  (ref) async {
    return await getPostList();
  },
);

final favoritePostsProvider = ChangeNotifierProvider<FavoritePostNotifier>(
  (ref) => FavoritePostNotifier(),
);

class FavoritePostNotifier extends ChangeNotifier {
  List<Post> favoriteList = [];

  Future getFavoritePostList() async {
    final allPosts = await getPostList();
    favoriteList = []; // 初期化して重複を防ぐ
    await Future.forEach(allPosts, (Post item) async {
      final isFavorite = await getFavorite('post', item.id);
      if (isFavorite) {
        favoriteList.add(item);
      }
    });
    notifyListeners();
  }

  // マイページでお気に入りから削除されたら実行
  void removeMyPageFavorite(int id) {
    final removedItem = favoriteList.firstWhere((element) => element.id == id);
    favoriteList.remove(removedItem);
    notifyListeners();
  }
}
