import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/providers.dart';
import 'package:flutter_sns_app/repository.dart';

class ChangeNamePage extends ConsumerStatefulWidget {
  const ChangeNamePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangeNamePage> createState() => ChangeNamePageState();
}

class ChangeNamePageState extends ConsumerState<ChangeNamePage> {
  final formKey = GlobalKey<FormState>();
  String formValue = 'ゲスト';

  @override
  void initState() {
    super.initState();
    Future(() async {
      final usernameData = await getUsername();
      setState(
        () {
          formValue = usernameData;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー名を変更'),
      ),
      // body:
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
                  initialValue: formValue,
                  decoration: const InputDecoration(
                    labelText: 'ユーザー名',
                  ),
                  onSaved: (value) {
                    formValue = value.toString();
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
                      setUsername(formValue);
                      ref
                          .read(usernameProvider.state)
                          .update((state) => formValue);
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
