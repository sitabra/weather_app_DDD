import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        key: const Key('snackBarMessage'),
      ),
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
