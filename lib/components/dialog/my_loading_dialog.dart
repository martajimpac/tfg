import 'package:flutter/material.dart';

class MyLoadingAlertDialog extends StatelessWidget {

  const MyLoadingAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      title: const Text(""),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}