import 'package:flutter/material.dart';

import '../../../core/generated/l10n.dart';
import '../../../core/theme/dimensions.dart';
import '../buttons/my_button.dart';

class MyOkDialog extends StatelessWidget {
  final String title;
  final String desc;
  final String buttonText;
  final Function()? onTap;

  const MyOkDialog({
    super.key,
    required this.title,
    required this.desc,
    required this.onTap,
    this.buttonText = '', // Valor por defecto
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
            MyButton(
              adaptableWidth: false,
              onTap: onTap,
              text: buttonText.isNotEmpty ? buttonText : S.of(context).accept,
            ),
          ],
        ),
      ),
    );
  }
}
