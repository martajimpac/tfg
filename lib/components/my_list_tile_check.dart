import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(Dimensions.marginMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.name,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCheckbox(Answer.si),
                buildCheckbox(Answer.no),
                buildCheckbox(Answer.na),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget buildCheckbox(Answer answer) {
    return Row(
      children: [
        Checkbox(
          activeColor: Theme.of(context).appBarTheme.iconTheme?.color,
          checkColor: Theme.of(context).colorScheme.primaryContainer,
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
