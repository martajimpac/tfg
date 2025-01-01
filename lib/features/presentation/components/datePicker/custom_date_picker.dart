
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../core/utils/Constants.dart';
import '../../../../core/utils/Utils.dart';


class CustomDatePicker extends StatefulWidget {
  final Function(DateTime?) onDateChanged;
  final ValueNotifier<DateTime?> selectedDateNotifier;
  final bool hasLimitDay;
  final bool isRed;

  const CustomDatePicker({
    Key? key,
    required this.onDateChanged,
    required this.selectedDateNotifier,
    this.hasLimitDay = true,
    this.isRed = false
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDateNotifier.value;
    widget.selectedDateNotifier.addListener(_handleSelectedDateChange);
  }

  @override
  void dispose() {
    widget.selectedDateNotifier.removeListener(_handleSelectedDateChange);
    super.dispose();
  }

  void _handleSelectedDateChange() {
    setState(() {
      _selectedDate = widget.selectedDateNotifier.value;
    });
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: widget.hasLimitDay ? DateTime.now() : Utils.calculateDate(context, 100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      widget.selectedDateNotifier.value = pickedDate;
      widget.onDateChanged(pickedDate);
    }
  }

  void _clearDate() {
    widget.selectedDateNotifier.value = null;
    widget.onDateChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDatePicker(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: widget.isRed ? Colors.red : Colors.grey, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.marginSmall,
          vertical: Dimensions.marginSmall,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
              ],
            ),
            GestureDetector(
              onTap: () {
                _clearDate();
              },
              child: const Icon(
                Icons.clear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}