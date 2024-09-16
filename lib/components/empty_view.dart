import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';

import '../generated/l10n.dart'; // Importa el archivo generado

class EmptyView extends StatelessWidget {
  final VoidCallback? onRetry;

  const EmptyView({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/images/ic_empty_view.png',
            width: 100,
            height: 100,
          ),
          Text(
            S.of(context).noEvaluations,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: Dimensions.marginMedium),
          Text(
            S.of(context).retryText,
          ),
          const SizedBox(height: Dimensions.marginMedium),
          MyButton(
            onTap: onRetry,
            text: S.of(context).retryTitle,
            adaptableWidth: true,
          ),
        ],
      ),
    );
  }
}
