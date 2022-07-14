import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/commonParts.dart';
import 'package:flutter_sns_app/providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void toggleIsDarkMode(WidgetRef ref) {
    ref.read(isDarkModeProvider).setIsDarkMode();
  }

  void toFormPage(BuildContext context) {
    Navigator.of(context).pushNamed('/my-page/settings/change-username');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Column(
        children: [
          Card(
            child: TextButton(
              onPressed: () => toFormPage(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('名前を登録'),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          Card(
            child: Row(
              children: [
                const Text('ダークモード'),
                Consumer(
                  builder: (context, ref, child) {
                    final darkModeState =
                        ref.watch(isDarkModeProvider).isDarkMode;
                    return Switch(
                      value: darkModeState,
                      onChanged: (value) {
                        ref.read(isDarkModeProvider).setIsDarkMode();
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
