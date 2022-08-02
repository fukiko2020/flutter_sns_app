import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/models/user.dart';
import 'package:flutter_sns_app/repositories/user.dart';

// 投稿・アルバムの投稿者情報表示に使用
final userListProvider = FutureProvider<List<User>>(
  (ref) async {
    return await getUsers();
  },
);

// マイページの「○○のお気に入り」に使用
final usernameProvider = StateProvider((ref) => 'ゲスト');

