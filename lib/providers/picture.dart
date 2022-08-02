import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/models/picture.dart';
import 'package:flutter_sns_app/repositories/common.dart';
import 'package:flutter_sns_app/repositories/picture.dart';


final pictureListProvider = FutureProvider.family<List<Picture>, int?>(
  (ref, albumIndex) async {
    return await getPictureList(albumIndex: albumIndex);
  },
);

final favoritePicturesProvider =
    ChangeNotifierProvider<FavoritePictureNotifier>(
  (ref) => FavoritePictureNotifier(),
);

class FavoritePictureNotifier extends ChangeNotifier {
  List<Picture> favoriteList = [];

  Future getFavoritePictureList() async {
    final allPictures = await getPictureList();
    favoriteList = []; // 初期化して重複を防ぐ
    await Future.forEach(allPictures, (Picture item) async {
      final isFavorite = await getFavorite('picture', item.id);
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
