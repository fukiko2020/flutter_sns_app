import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_sns_app/models/user.dart';
import 'package:flutter_sns_app/repository.dart';

// BottomNavigationBar の選択中タブ 最初は投稿一覧ページ
final currentTabProvider = StateProvider<int>((ref) => 0);

final userListProvider = FutureProvider<List<User>>((ref) async {
  return await getUsers();
});
