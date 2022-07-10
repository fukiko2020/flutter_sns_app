import 'dart:convert' as convert;
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

Future<bool> getFavorite(String type, int index) async {
  final data = await SharedPreferences.getInstance();
  return Future<bool>.value(data.getBool('$type$index'));
}

void setFavorite(String type, int index, bool isFavorite) async {
  final data = await SharedPreferences.getInstance();
  data.setBool('$type$index', !isFavorite);
}
