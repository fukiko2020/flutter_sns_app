import 'dart:convert' as convert;
import 'package:flutter_sns_app/constants.dart';
import 'package:flutter_sns_app/models/picture.dart';
import 'package:http/http.dart' as http;


Future<List<Picture>> getPictureList({int? albumIndex}) async {
  final List<Picture> pictureList;
  final queryParam = albumIndex == null ? '' : '?albumId=$albumIndex';
  final response = await http.get(
    Uri.parse('$url/photos$queryParam'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> pictureData = convert.jsonDecode(response.body);
    pictureList = pictureData.map((e) => Picture.fromJson(e)).toList();
    return Future<List<Picture>>.value(pictureList);
  } else {
    throw Exception('Failed to fetch data');
  }
}
