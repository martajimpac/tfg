import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTwoButtonsDialog extends StatelessWidget {
  final String title;
  final String desc;
  final Function()? onPrimaryButtonTap;
  final Function()? onSecondaryButtonTap;
  final String primaryButtonText;
  final String secondaryButtonText;

  const MyTwoButtonsDialog({
    Key? key,
    required this.title,
    required this.desc,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    this.onPrimaryButtonTap,
    this.onSecondaryButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Dimensions.marginMedium),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        padding: const EdgeInsets.all(Dimensions.marginMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Dimensions.marginMedium), // Espacio entre el título y el texto siguiente
            Text(
              desc,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.marginMedium),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: MyButton(
                      adaptableWidth: false,
                      onTap: onSecondaryButtonTap,
                      text: secondaryButtonText,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: MyButton(
                      adaptableWidth: false,
                      onTap: onPrimaryButtonTap,
                      text: primaryButtonText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
