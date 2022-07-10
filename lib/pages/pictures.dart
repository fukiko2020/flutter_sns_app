import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/commonParts.dart';
import 'package:flutter_sns_app/models/picture.dart';
import 'package:flutter_sns_app/repository.dart';

class PicturesPage extends ConsumerWidget {
  const PicturesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var albumIndex = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('写真'),
      ),
      body: FutureBuilder<List<Picture>>(
        future: albumIndex == null
            ? getPictureList()
            : getPictureList(albumIndex: albumIndex as int),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ), // カラム数
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final picture = snapshot.data![index];
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: Image.network(picture.thumbnailUrl),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: FavoriteWidget(index: picture.id, type: 'picture'),
                      ),
                    ],
                  );
                });
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}