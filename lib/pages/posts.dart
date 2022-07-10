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
    final userList = ref.watch(userListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿'),
      ),
      body: FutureBuilder<List<Post>>(
        future: getPostList(),
        builder: (context, postSnapshot) {
          if (postSnapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final post = postSnapshot.data![index];
                return Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: userList.when(
                          data: (data) => [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, top: 20, right: 8),
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
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Text(
                          post.title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
                        child: FavoriteWidget(index: index, type: 'post'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (postSnapshot.hasError) {
            return Text('Error: ${postSnapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
