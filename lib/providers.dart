import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/models/album.dart';
import 'package:flutter_sns_app/models/picture.dart';
import 'package:flutter_sns_app/models/post.dart';
import 'package:flutter_sns_app/models/user.dart';
import 'package:flutter_sns_app/repository.dart';

// BottomNavigationBar の選択中タブ 最初は投稿一覧ページ
final currentTabProvider = StateProvider<int>((ref) => 0);

final userListProvider = FutureProvider<List<User>>(
  (ref) async {
    return await getUsers();
  },
);

final favoritePostsProvider = ChangeNotifierProvider<FavoritePostNotifier>(
    (ref) => FavoritePostNotifier());

class FavoritePostNotifier extends ChangeNotifier {
  List<Post> favoriteList = [];

  Future getFavoritePostList() async {
    print('---execute getFavoritePostList---');
    final allPosts = await getPostList();
    favoriteList = []; // 初期化して重複を防ぐ
    await Future.forEach(allPosts, (Post item) async {
      final isFavorite = await getFavorite('post', item.id);
      if (isFavorite) {
        print('favorite post id: ${item.id}');
        favoriteList.add(item);
      }
    });
    print('favorite in provider: $favoriteList');
    notifyListeners();
  }

  // マイページでお気に入りから削除されたら実行
  void removeMyPageFavorite(int id) {
    final removedItem = favoriteList.firstWhere((element) => element.id == id);
    print('removed item in provider: ${removedItem.id}');
    favoriteList.remove(removedItem);
    notifyListeners();
  }
}

final favoriteAlbumsProvider = ChangeNotifierProvider<FavoriteAlbumNotifier>(
    (ref) => FavoriteAlbumNotifier());

class FavoriteAlbumNotifier extends ChangeNotifier {
  List<Album> favoriteList = [];

  Future getFavoriteAlbumList() async {
    print('---execute getFavoriteAlbumList---');
    final allAlbums = await getAlbumList();
    favoriteList = []; // 初期化して重複を防ぐ
    await Future.forEach(allAlbums, (Album item) async {
      final isFavorite = await getFavorite('album', item.id);
      if (isFavorite) {
        print('favorite album id: ${item.id}');
        favoriteList.add(item);
      }
    });
    print('favorite in provider: $favoriteList');
    notifyListeners();
  }

  // マイページでお気に入りから削除されたら実行
  void removeMyPageFavorite(int id) {
    final removedItem = favoriteList.firstWhere((element) => element.id == id);
    print('removed item in provider: ${removedItem.id}');
    favoriteList.remove(removedItem);
    notifyListeners();
  }
}

final favoritePicturesProvider =
    ChangeNotifierProvider<FavoritePictureNotifier>(
  (ref) => FavoritePictureNotifier(),
);

class FavoritePictureNotifier extends ChangeNotifier {
  List<Picture> favoriteList = [];

  Future getFavoritePictureList() async {
    print('---execute getFavoritePictureList---');
    final allPictures = await getPictureList();
    favoriteList = []; // 初期化して重複を防ぐ
    await Future.forEach(allPictures, (Picture item) async {
      final isFavorite = await getFavorite('picture', item.id);
      if (isFavorite) {
        print('favorite picture id: ${item.id}');
        favoriteList.add(item);
      }
    });
    print('favorite in provider: $favoriteList');
    notifyListeners();
  }

  // マイページでお気に入りから削除されたら実行
  void removeMyPageFavorite(int id) {
    final removedItem = favoriteList.firstWhere((element) => element.id == id);
    print('removed item in provider: ${removedItem.id}');
    favoriteList.remove(removedItem);
    notifyListeners();
  }
}

// マイページの「○○のお気に入り」に使用
final usernameProvider = StateProvider((ref) => 'ゲスト');

final isDarkModeProvider =
    ChangeNotifierProvider<IsDarkModeNotifier>((ref) => IsDarkModeNotifier());

class IsDarkModeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  Future getIsDarkMode() async {
    isDarkMode = await getIsDarkModeData();
    notifyListeners();
  }

  void setIsDarkMode() {
    isDarkMode = !isDarkMode;
    setIsDarkModeData(!isDarkMode);
    notifyListeners();
  }
}
