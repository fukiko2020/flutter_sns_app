import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/providers/user.dart';
import 'package:flutter_sns_app/repositories/user.dart';

class ChangeNamePage extends ConsumerWidget {
  final formKey = GlobalKey<FormState>();

  ChangeNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー名を変更'),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32.0),
                padding: const EdgeInsets.all(4.0),
                width: 300,
                child: TextFormField(
                  // SharedPreferences に保存されている値を初期値に指定
                  initialValue: ref.watch(usernameProvider),
                  decoration: const InputDecoration(
                    labelText: 'ユーザー名',
                  ),
                  onSaved: (value) {
                    final valueStr = value.toString();
                    setUsername(valueStr);
                    ref
                        .read(usernameProvider.state)
                        .update((state) => valueStr);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ユーザー名を入力してください。';
                    } else if (value.length > 20) {
                      return 'ユーザー名は20文字以内で入力してください。';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('ユーザー名を変更'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
