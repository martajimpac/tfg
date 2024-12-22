
import 'package:evaluacionmaquinas/presentation/components/textField/my_login_textfield.dart';
import 'package:flutter/material.dart';
import '../../core/generated/l10n.dart';
import '../../core/theme/dimensions.dart';
import '../../data/models/opcion_respuesta_dm.dart';


class MyListTile extends StatefulWidget {
  final String text;
  final List<OpcionRespuestaDataModel> listAnswers;
  final OpcionRespuestaDataModel? answerSelected;
  final Function(OpcionRespuestaDataModel) onAnswerSelected;
  final Function(String) onObservationsChanged;
  final bool isAnswered;
  final bool tieneObservaciones;
  final String observaciones;

  const MyListTile({
    super.key,
    required this.text,
    required this.listAnswers,
    required this.answerSelected,
    required this.onAnswerSelected,
    required this.onObservationsChanged,
    this.isAnswered = false,
    this.tieneObservaciones = false,
    this.observaciones = "", //TODO PASARLE SOLO LA VARIABLE PREGUNTA!!!
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  OpcionRespuestaDataModel? selectedAnswer;
  bool _isAnswered = false;
  final _observacionesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.answerSelected;
    _isAnswered = widget.isAnswered;
    _observacionesController.text = widget.observaciones;
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.marginSmall,
        horizontal: Dimensions.marginMedium,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginMedium),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isAnswered
                ? Theme.of(context).colorScheme.secondaryContainer
                : Colors.white,
          ),
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Dimensions.marginMedium),
            Text(widget.text),
            const SizedBox(height: Dimensions.marginSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.listAnswers.map((answer) {
                return buildCheckbox(answer, widget.listAnswers[0]);
              }).toList(),
            ),
            if (widget.tieneObservaciones) ...[
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    S.of(context).observationsTitle,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: Dimensions.smallTextSize),
                  ),
                  trailing: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      semanticLabel: 'Mostrar observaciones'
                  ),
                  children: [
                    MyLoginTextField(
                      controller: _observacionesController,
                      hintText: S.of(context).observationsDesc,
                      onTextChanged: widget.onObservationsChanged,
                    ),
                  ],
                ),
              ),
            ] else
              const SizedBox(height: Dimensions.marginMedium),
          ],
        ),
      ),
    );
  }

  Widget buildCheckbox(OpcionRespuestaDataModel answer, OpcionRespuestaDataModel defaultAnswer) {
    return Row(
      children: [
        Checkbox(
          activeColor: _isAnswered ? Theme.of(context).appBarTheme.iconTheme?.color : Colors.grey,
          checkColor: Theme.of(context).colorScheme.surface,
          value: _isAnswered ? answer == selectedAnswer : answer == defaultAnswer,
          onChanged: (value) {
            setState(() {
              _isAnswered = true;
              selectedAnswer = answer;
            });
            widget.onAnswerSelected(answer);
          },
        ),
        Text(answer.opcion),
      ],
    );
  }
}
