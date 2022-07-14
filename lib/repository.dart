import 'dart:convert' as convert;
import 'package:flutter_sns_app/models/album.dart';
import 'package:flutter_sns_app/models/picture.dart';
import 'package:flutter_sns_app/models/post.dart';
import 'package:flutter_sns_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<User>> getUsers() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> userData = convert.jsonDecode(response.body);
    final userList = userData.map((e) => User.fromJson(e)).toList();
    return Future<List<User>>.value(userList);
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<List<Post>> getPostList() async {
  final List<Post> postList;
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> postData = convert.jsonDecode(response.body);
    postList = postData.map((e) => Post.fromJson(e)).toList();
    return Future<List<Post>>.value(postList);
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<List<Post>> getFavoritePostList() async {
  final List<Post> postList;
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> postData = convert.jsonDecode(response.body);
    postList = postData.map((e) => Post.fromJson(e)).toList();
    return Future<List<Post>>.value(postList);
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<List<Album>> getAlbumList() async {
  final List<Album> albumList;
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> albumData = convert.jsonDecode(response.body);
    albumList = albumData.map((e) => Album.fromJson(e)).toList();
    return Future<List<Album>>.value(albumList);
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<List<Picture>> getPictureList({int? albumIndex}) async {
  final List<Picture> pictureList;
  final queryParam = albumIndex == null ? '' : '?albumId=$albumIndex';
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/photos$queryParam'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> pictureData = convert.jsonDecode(response.body);
    pictureList = pictureData.map((e) => Picture.fromJson(e)).toList();
    return Future<List<Picture>>.value(pictureList);
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<bool> getFavorite(String type, int id) async {
  final data = await SharedPreferences.getInstance();
  final isFavorite = data.getBool('$type$id');
  return isFavorite == null ? Future.value(false) : Future.value(isFavorite);
}

void setFavorite(String type, int id, bool isFavorite) async {
  final data = await SharedPreferences.getInstance();
  data.setBool('$type$id', !isFavorite);
  print('set favorite $type: $id');
}

Future<String> getUsername() async {
  final data = await SharedPreferences.getInstance();
  final username = data.getString('username');
  return username == null ? Future.value('ゲスト') : Future.value(username);
}

void setUsername(String newUsername) async {
  final data = await SharedPreferences.getInstance();
  data.setString('username', newUsername);
}

Future<bool> getIsDarkModeData() async {
  final data = await SharedPreferences.getInstance();
  final isDarkMode = data.getBool('isDarkMode');
  return isDarkMode == null ? Future.value(true) : Future.value(isDarkMode);
}

void setIsDarkModeData(bool currentValue) async {
  final data = await SharedPreferences.getInstance();
  data.setBool('isDarkMode', !currentValue);
}
