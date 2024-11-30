
import 'package:evaluacionmaquinas/components/dialog/my_image_dialog.dart';
import 'package:flutter/material.dart';

import '../../theme/dimensions.dart';
import '../buttons/my_button.dart';

class MyContentDialog extends StatelessWidget {
  final Text title;
  final Container content;
  final Function()? onPrimaryButtonTap;
  final Function()? onSecondaryButtonTap;
  final String primaryButtonText;
  final String secondaryButtonText;

  const MyContentDialog({
    super.key,
    required this.title,
    required this.content,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    this.onPrimaryButtonTap,
    this.onSecondaryButtonTap,
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
          color: Theme.of(context).colorScheme.onBackground,
        ),
        padding: const EdgeInsets.all(Dimensions.marginMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title,
            const SizedBox(height: Dimensions.marginMedium), // Espacio entre el título y el texto siguiente
            content,
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
                      color: Colors.grey.shade700
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
