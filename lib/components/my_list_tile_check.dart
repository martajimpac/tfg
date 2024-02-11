import 'package:flutter/material.dart';
import 'package:modernlogintute/theme/dimensions.dart';

import '../views/checklist_page.dart';

class MyListTile extends StatefulWidget {
  final String name;
  final Answer answerSelected;

  const MyListTile({Key? key, required this.name, required this.answerSelected}) : super(key: key);

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  Answer? selectedAnswer = Answer.notselected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.marginMedium), //TODO QUITAR MARGEN ARRIBA Y A LA DERECHA PONER MENOS todo pasar resultado a dfjasdlf

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.name),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCheckbox(Answer.si),
                  buildCheckbox(Answer.no),
                  buildCheckbox(Answer.na),
                ],
              ),
            ]
        ),
    );
  }

  Widget buildCheckbox(Answer answer) {
    return Row(
      children: [
        Checkbox(
          activeColor: Theme.of(context).appBarTheme.iconTheme?.color,
          value: answer == selectedAnswer,
          onChanged: (value) {
            setState(() {
              selectedAnswer = answer;
            });
          },
        ),
        Text(answer.text),
      ],
    );
  }
}
