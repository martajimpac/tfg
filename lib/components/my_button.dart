import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool adaptableWidth;

  const MyButton({
    Key? key,
    required this.adaptableWidth,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            constraints: BoxConstraints(
              minWidth: adaptableWidth ? 0 : double.infinity,
            ),
            child: Text(
              text,
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
