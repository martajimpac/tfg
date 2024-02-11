import 'package:flutter/material.dart';
import 'package:modernlogintute/theme/app_theme.dart';
import 'package:modernlogintute/theme/dimensions.dart';


class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool adaptableWidth;

  const MyButton({
    super.key,
    required this.adaptableWidth,
    required this.onTap,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.marginButton),
            margin:  const EdgeInsets.all(Dimensions.marginMedium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            constraints: BoxConstraints(
              minWidth: adaptableWidth? 0 : double.infinity
            ),
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer
              ),
              textAlign: TextAlign.center,
            ),
          )
        ]
      )
    );
  }
}
