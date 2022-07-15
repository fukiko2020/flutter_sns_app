import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/commonParts.dart';
import 'package:flutter_sns_app/models/post.dart';
import 'package:flutter_sns_app/providers.dart';
import 'package:flutter_sns_app/repository.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿'),
      ),
      body: FutureBuilder<List<Post>>(
          future: getPostList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PostsWidget(postList: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          }
          ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}

// 投稿一覧とマイページのお気に入り投稿一覧で使用
class PostsWidget extends ConsumerWidget {
  final List<Post> postList;
  final bool isMyPage;
  const PostsWidget({
    super.key,
    required this.postList,
    this.isMyPage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: postList.length,
      itemBuilder: (context, index) {
        final post = postList[index];
        return PostWidget(
          id: post.id,
          post: post,
          isMyPage: isMyPage,
        );
      },
    );
  }
}

class PostWidget extends ConsumerWidget {
  final int id;
  final Post post;
  final bool isMyPage;

  const PostWidget({
    super.key,
    required this.id,
    required this.post,
    this.isMyPage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userList = ref.watch(userListProvider);
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: userList.when(
              data: (data) => [
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 20, right: 8),
                  child: Text(data[post.userId].name),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    '@${data[post.userId].username}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
              loading: () => [
                const Text('loading user info...'),
              ],
              error: (err, stack) => [
                Text('Error: $err'),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Text(
              post.title,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              post.body,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 20),
            child: FavoriteWidget(
              id: id,
              type: 'post',
              isMyPage: isMyPage,
            ),
          ),
        ],
      ),
    );
  }
}
