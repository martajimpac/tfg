
import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';
import '../buttons/my_button.dart';

class MyTwoButtonsDialog extends StatelessWidget {
  final String title;
  final String desc;
  final Function()? onPrimaryButtonTap;
  final Function()? onSecondaryButtonTap;
  final String primaryButtonText;
  final String secondaryButtonText;
  final bool isVertical; // Nuevo parámetro para determinar la orientación de los botones

  const MyTwoButtonsDialog({
    super.key,
    required this.title,
    required this.desc,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    this.onPrimaryButtonTap,
    this.onSecondaryButtonTap,
    this.isVertical = false, // Por defecto los botones serán horizontales
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Dimensions.marginMedium),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
          color: Theme.of(context).colorScheme.onPrimary,
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
            const SizedBox(height: Dimensions.marginMedium),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: Dimensions.marginMedium),
            isVertical
                ? Column( // Disposición vertical
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: MyButton(
                    adaptableWidth: false,
                    onTap: onSecondaryButtonTap,
                    text: secondaryButtonText,
                    color: Colors.grey.shade700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: MyButton(
                    adaptableWidth: false,
                    onTap: onPrimaryButtonTap,
                    text: primaryButtonText,
                  ),
                ),
              ],
            )
                : Row( // Disposición horizontal
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: MyButton(
                      adaptableWidth: false,
                      onTap: onSecondaryButtonTap,
                      text: secondaryButtonText,
                      color: Colors.grey.shade700,
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
