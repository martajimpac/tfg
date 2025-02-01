
import 'package:evaluacionmaquinas/features/presentation/components/textField/my_textform_field.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/dimensions.dart';
import '../../../generated/l10n.dart';
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
    this.observaciones = "",
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  OpcionRespuestaDataModel? _answerSelected;
  bool _isAnswered = false;
  final _observacionesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint("MARTA INIT");
    _answerSelected = widget.answerSelected;
    _isAnswered = widget.isAnswered;
    _observacionesController.text = widget.observaciones;
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MyListTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    debugPrint("MARTA UPDATE");
    // Solo sincroniza si las propiedades cambian
    _answerSelected = widget.answerSelected;
    _isAnswered = widget.isAnswered;
    _observacionesController.text = widget.observaciones;

  }

  @override
  Widget build(BuildContext context) {
    debugPrint("MARTA build");
    // Actualizar estado según las propiedades del widget
    /*if (_answerSelected != widget.answerSelected) {
      _answerSelected = widget.answerSelected;
    }
    if (_isAnswered != widget.isAnswered) {
      _isAnswered = widget.isAnswered;
    }
    if (_observacionesController.text != widget.observaciones) {
      _observacionesController.text = widget.observaciones;
    }*/

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
                  initiallyExpanded: widget.observaciones != "",
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    S.of(context).observationsTitle,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: Dimensions.smallTextSize),
                  ),
                  trailing: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      semanticLabel: S.of(context).semanticlabelShowObservations
                  ),
                  children: [
                    MyTextFormField(
                      controller: _observacionesController,
                      hintText: S.of(context).observationsDesc,
                      onTextChanged: (observaciones) {
                        widget.onObservationsChanged(observaciones);
                      },
                      numLines: 2,
                      backgroundColor: Theme.of(context).colorScheme.surface,
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
          value: _isAnswered ? answer == _answerSelected : answer == defaultAnswer,
          onChanged: (value) {
            setState(() {
              _isAnswered = true;
              _answerSelected = answer;
            });
            widget.onAnswerSelected(answer);
          },
        ),
        Text(answer.opcion),
      ],
    );
  }
}
