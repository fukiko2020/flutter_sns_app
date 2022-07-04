import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'album.freezed.dart';

@freezed
class Album with _$Album {
  factory Album({
    required int userId,
    required int id,
    required String title,
  }) = _Album;

  factory Album.fromJson(Map<String, Object?> json) => _$AlbumFromJson(json);
}
