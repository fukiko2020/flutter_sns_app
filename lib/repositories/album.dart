import 'dart:convert' as convert;
import 'package:flutter_sns_app/constants.dart';
import 'package:flutter_sns_app/models/album.dart';
import 'package:http/http.dart' as http;


Future<List<Album>> getAlbumList() async {
  final List<Album> albumList;
  final response = await http.get(
    Uri.parse('$url/albums'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> albumData = convert.jsonDecode(response.body);
    albumList = albumData.map((e) => Album.fromJson(e)).toList();
    return Future<List<Album>>.value(albumList);
  } else {
    throw Exception('Failed to fetch data');
  }
}
