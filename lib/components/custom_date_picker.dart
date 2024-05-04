import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  const CustomDatePicker({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;

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
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due date',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
              ),
              Text(
                DateFormat('MMM, dd yyyy').format(_selectedDate),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoDatePicker(
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
            maximumDate: DateTime(2050, 12, 30),
            minimumYear: 2010,
            maximumYear: 2018,
            minuteInterval: 1,
            mode: CupertinoDatePickerMode.dateAndTime,
          ),
        ),
      ],
    );
  }
}
