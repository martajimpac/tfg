import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:flutter/material.dart';

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
            'No hay evaluaciones',
            style: Theme.of(context).textTheme.headlineMedium
          ),
          const SizedBox(height: Dimensions.marginMedium),
          const Text(
              '¿Desea volver a intentarlo?'
          ),
          const SizedBox(height: Dimensions.marginMedium),
          MyButton(
            onTap: onRetry,
            text: "Reintentar",
            adaptableWidth: true,
          ),
        ],
      ),
    );
  }
}
