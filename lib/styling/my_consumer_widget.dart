import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './app_theme_data.dart';

class MyConsumerWidget extends ConsumerWidget {
  const MyConsumerWidget({Key? key}) : super(key: key);

  Future<bool> showValidationDialog({
    required BuildContext context,
    required String title,
    String? description,
    required bool isForConfirmation,
    Widget? descriptionWidget,
    Icon? icon,
  }) async {
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
              descriptionWidget: descriptionWidget,
              width: MediaQuery.of(context).size.width * 0.8,
              isForConfirmation: isForConfirmation,
              icon: icon,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}
