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
  final int? idDefaultAnswer;
  final bool isAnswered;
  final bool tieneObservaciones;
  final String observaciones;
  final String? textoAux;

  const MyListTile({
    super.key,
    required this.text,
    required this.listAnswers,
    required this.answerSelected,
    required this.onAnswerSelected,
    required this.onObservationsChanged,
    required this.idDefaultAnswer,
    this.isAnswered = false,
    this.tieneObservaciones = false,
    this.observaciones = "",
    this.textoAux,
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
    _answerSelected = widget.answerSelected;
    _isAnswered = widget.isAnswered;
    _observacionesController.text = widget.observaciones;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.marginSmall,
        horizontal: Dimensions.marginMedium,
      ),

      child: Column(
        children: [

          // Añadimos el texto auxiliar si no es nulo
          if (widget.textoAux != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: Dimensions.marginMedium,
                left: Dimensions.marginMedium,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.textoAux!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.smallTextSize,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.marginSmall),
          ],

          Container(
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
                    return buildCheckbox(answer, widget.idDefaultAnswer);
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: Dimensions.smallTextSize
                        ),
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
        ],

      )


    );
  }

  Widget buildCheckbox(OpcionRespuestaDataModel answer, int? idDefaultAnswer) {
    return Row(
      children: [
        Checkbox(
          activeColor: _isAnswered
              ? Theme.of(context).appBarTheme.iconTheme?.color
              : Colors.grey,
          checkColor: Theme.of(context).colorScheme.surface,
          value: _isAnswered
              ? answer == _answerSelected
              : answer.idopcion == idDefaultAnswer,
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