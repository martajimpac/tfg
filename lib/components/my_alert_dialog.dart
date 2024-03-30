import 'package:flutter/material.dart';


class MyAlertDialog extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final String desc;
  final Container content;

  const MyAlertDialog({
    super.key,
    required this.onTap,
    required this.title,
    required this.desc,
    required this.content
  });

  //TODO PERSONALICE COLORS
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(desc),
      actions: [
        TextButton(
          onPressed: onTap,
          child: content,
        ),
      ],
    );
  }
}
