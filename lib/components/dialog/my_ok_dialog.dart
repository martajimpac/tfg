import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:flutter/material.dart';

import '../../theme/dimensions.dart';


class MyOkDialog extends StatelessWidget {
  final String title;
  final String desc;
  final Function()? onTap;

  const MyOkDialog({
    super.key,
    required this.title,
    required this.desc,
    required this.onTap,
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
            const SizedBox(height: Dimensions.marginMedium),
            Text(
              desc,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.marginMedium),
            MyButton(
              adaptableWidth: false,
              onTap: onTap,
              text: "Ok",
            ),
          ],
        ),
      ),
    );
  }
}
