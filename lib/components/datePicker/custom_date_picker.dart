import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime)? onDateChanged;

  const CustomDatePicker({
    Key? key,
    this.onDateChanged,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  Future<void> _showDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      if (widget.onDateChanged != null) {
        widget.onDateChanged!(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDatePicker(context);
      },
      child: Container(
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
              _selectedDate != null
                  ? DateFormat(DateFormatString).format(_selectedDate!)
                  : "-- / -- / ---- ",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: Dimensions.smallTextSize,
              ),
            ),
            const Icon(Icons.calendar_today_rounded),
          ],
        ),
      ),
    );
  }
}

