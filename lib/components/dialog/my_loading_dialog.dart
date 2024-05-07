import 'package:flutter/material.dart';

class MyLoadingAlertDialog extends StatelessWidget {

  const MyLoadingAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text(""),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}