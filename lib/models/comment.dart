import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'comment.freezed.dart';

@freezed
class Comment with _$Comment {
  factory Comment({
    required int postId,
    required int id,
    required String email,
    required String body,
  }) = _Comment;

  factory Comment.fromJson(Map<String, Object?> json) =>
      _$CommentFromJson(json);
}
