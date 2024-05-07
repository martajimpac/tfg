import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../theme/dimensions.dart';

class CustomDatePickerScroll extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  const CustomDatePickerScroll({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePickerScroll> {
  late DateTime _selectedDate;
  bool _showDatePicker = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat(DateFormatString).format(_selectedDate),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: Dimensions.smallTextSize,
                ),
              ),
              GestureDetector(
                child: Text('Cambiar'),
                onTap: () {
                  setState(() {
                    _showDatePicker = !_showDatePicker;
                  });
                },
              )
            ],
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _showDatePicker ? MediaQuery.of(context).size.height / 3 : 0,
          child: _showDatePicker
              ? CupertinoDatePicker(
            initialDateTime: _selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
              });
              if (widget.onDateChanged != null) {
                widget.onDateChanged(newDate);
              }
            },
            use24hFormat: true,
            minimumYear: widget.initialDate.year - 1,
            maximumYear: widget.initialDate.year + 8,
            mode: CupertinoDatePickerMode.date,
          )
              : null,
        ),
      ],
    );
  }
}
