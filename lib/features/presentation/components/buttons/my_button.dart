
import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool adaptableWidth;
  final Color? color;
  final bool roundBorders;

  const MyButton({
    super.key,
    required this.adaptableWidth,
    required this.onTap,
    required this.text,
    this.color,
    this.roundBorders = true
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primaryContainer;

    return GestureDetector(
      onTap: onTap,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Dimensions.marginButtonVertical,
              horizontal: Dimensions.marginButton,
            ),
            //margin: const EdgeInsets.symmetric(vertical: Dimensions.marginSmall),
            decoration: BoxDecoration(
              borderRadius: roundBorders ? BorderRadius.circular(Dimensions.cornerRadiusButton) : BorderRadius.zero ,
              color: buttonColor,
            ),
            constraints: BoxConstraints(
              minWidth: adaptableWidth ? 0 : double.infinity,
            ),
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.defaultTextSize,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
