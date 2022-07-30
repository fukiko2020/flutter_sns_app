import 'package:shared_preferences/shared_preferences.dart';


// type ('post' / 'album' / 'picture') の指定された id のいいね状態を取得
Future<bool> getFavorite(String type, int id) async {
  final data = await SharedPreferences.getInstance();
  final isFavorite = data.getBool('$type$id');
  return isFavorite == null ? Future.value(false) : Future.value(isFavorite);
}

// type ('post' / 'album' / 'picture') の指定された id のいいねを設定
void setFavorite(String type, int id, {bool isFavorite = false}) async {
  final data = await SharedPreferences.getInstance();
  data.setBool('$type$id', !isFavorite);
}


// ダークモード設定を取得
Future<bool> getIsDarkModeData() async {
  final data = await SharedPreferences.getInstance();
  final isDarkMode = data.getBool('isDarkMode');
  return isDarkMode == null ? Future.value(true) : Future.value(isDarkMode);
}

// currentValue: 現在の isDarkMode の値
void setIsDarkModeData({bool currentValue = false}) async {
  final data = await SharedPreferences.getInstance();
  data.setBool('isDarkMode', !currentValue);
}
