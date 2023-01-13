import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme_data.dart';

class MyConsumerStatefulWidget extends ConsumerStatefulWidget {
  const MyConsumerStatefulWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<MyConsumerStatefulWidget> createState() =>
      _MyConsumerStatefulWidgetState();
}

class _MyConsumerStatefulWidgetState
    extends ConsumerState<MyConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class MyConsumerState<T> extends ConsumerState {
  Future<bool> showValidationDialog(BuildContext context, String title,
      String description, bool isForConfirmation) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: ValidationDialog(
              title: title,
              description: description,
              width: MediaQuery.of(context).size.width * 0.8,
              isForConfirmation: isForConfirmation,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
