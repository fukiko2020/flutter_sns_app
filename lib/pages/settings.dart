import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/common_parts.dart';
import 'package:flutter_sns_app/providers/common.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void toFormPage(BuildContext context) {
    Navigator.of(context).pushNamed('/my_page/settings/change_username');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Column(
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 42,
              ),
              child: TextButton(
                onPressed: () => toFormPage(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '名前を登録',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.only(
                left: 50,
                top: 12,
                right: 40,
                bottom: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ダークモード',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      ref.read(isDarkModeProvider).setIsDarkMode();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
