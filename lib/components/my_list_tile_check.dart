import 'package:evaluacionmaquinas/modelos/opcion_respuesta_dm.dart';
import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import '../generated/l10n.dart';
import '../views/checklist_page.dart';

class MyListTile extends StatefulWidget {
  final String text;
  final List<OpcionRespuestaDataModel> listAnswers;
  final OpcionRespuestaDataModel? answerSelected;
  final Function(OpcionRespuestaDataModel) onAnswerSelected;
  final bool isAnswered;
  final bool tieneObservaciones;

  const MyListTile({
    super.key,
    required this.text,
    required this.listAnswers,
    required this.answerSelected,
    required this.onAnswerSelected,
    this.isAnswered = false, //por defecto false
    this.tieneObservaciones = false,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  OpcionRespuestaDataModel? selectedAnswer;
  bool _isAnswered = false;
  String _observaciones = '';

  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.answerSelected;
    _isAnswered = widget.isAnswered;
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.marginSmall, horizontal: Dimensions.marginMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:Dimensions.marginMedium),
        decoration: BoxDecoration(
          border: Border.all(color: _isAnswered ? Theme.of(context).colorScheme.secondaryContainer : Colors.white),
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Dimensions.marginMedium),
            Text(
              widget.text,
            ),
            const SizedBox(height: Dimensions.marginSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCheckbox(widget.listAnswers[0], widget.listAnswers[0]),
                buildCheckbox(widget.listAnswers[1], widget.listAnswers[0]),
                buildCheckbox(widget.listAnswers[2], widget.listAnswers[0]),
              ],
            ),
          if (widget.tieneObservaciones) ...[
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  S.of(context).observationsTitle,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                ),
                trailing: Icon(Icons.keyboard_arrow_down_rounded),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _observaciones = value;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8.0), // Ajusta el radio según sea necesario
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(8.0), // Ajusta el radio según sea necesario
                        ),
                        hintText: S.of(context).observationsDesc,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ]else
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
          checkColor: Theme.of(context).colorScheme.background,
          value: _isAnswered
              ? answer == selectedAnswer
              : answer == defaultAnswer,
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
