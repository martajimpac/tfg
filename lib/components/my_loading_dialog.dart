import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {

  const LoadingAlertDialog({super.key});

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