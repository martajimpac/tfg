import 'package:evaluacionmaquinas/modelos/opcion_respuesta_dm.dart';
import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import '../views/checklist_page.dart';

class MyListTile extends StatefulWidget {
  final String name;
  final List<OpcionRespuestaDataModel> listAnswers;
  final OpcionRespuestaDataModel? answerSelected;
  final Function(OpcionRespuestaDataModel) onAnswerSelected;
  final bool isRed;

  const MyListTile({
    Key? key,
    required this.name,
    required this.listAnswers,
    required this.answerSelected,
    required this.onAnswerSelected,
    this.isRed = false,
  }) : super(key: key);

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  OpcionRespuestaDataModel? selectedAnswer;
  bool _isRed = false;

  @override
  void initState() {
    selectedAnswer = widget.answerSelected;
    _isRed = widget.isRed;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: Dimensions.marginSmall),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.marginMedium),
        decoration: BoxDecoration(
          border: Border.all(color: _isRed ? Colors.red : Colors.white),
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.name,
            ),
            const SizedBox(height: Dimensions.marginMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCheckbox(widget.listAnswers[0]),
                buildCheckbox(widget.listAnswers[1]),
                buildCheckbox(widget.listAnswers[2]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckbox(OpcionRespuestaDataModel answer) {
    return Row(
      children: [
        Checkbox(
          activeColor: Theme.of(context).appBarTheme.iconTheme?.color,
          checkColor: Theme.of(context).colorScheme.background,
          value: answer == selectedAnswer,
          onChanged: (value) {
            setState(() {
              _isRed = false;
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
