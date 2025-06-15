import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../core/utils/Constants.dart';
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
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        padding: const EdgeInsets.all(Dimensions.marginMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title,
            const SizedBox(height: Dimensions.marginMedium),
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
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: MyButton(
                      key: primaryButtonKey,
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
