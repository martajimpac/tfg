import 'package:evaluacionmaquinas/utils/Utils.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../generated/l10n.dart';

class CustomDatePickerRange extends StatefulWidget {
  final Function(DateTime?) onDateChanged;
  final ValueNotifier<DateTime?> selectedDateNotifier;
  final bool hasLimitDay;
  final bool isRed;

  const CustomDatePickerRange({
    super.key,
    required this.onDateChanged,
    required this.selectedDateNotifier,
    this.hasLimitDay = true,
    this.isRed = false
  });

  @override
  _CustomDatePickerRangeState createState() => _CustomDatePickerRangeState();
}

class _CustomDatePickerRangeState extends State<CustomDatePickerRange> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDateNotifier.value as String;
    widget.selectedDateNotifier.addListener(_handleSelectedDateChange);
  }

  @override
  void dispose() {
    widget.selectedDateNotifier.removeListener(_handleSelectedDateChange);
    super.dispose();
  }

  void _handleSelectedDateChange() {
    setState(() {
      _selectedDate = widget.selectedDateNotifier.value as String;
    });
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  void _showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date Range'),
          content: Container(
            height: 400, // Ajusta la altura según sea necesario
            width: 300,  // Ajusta el ancho según sea necesario
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).accept),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearDate() {
    widget.selectedDateNotifier.value = null;
    widget.onDateChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDatePickerDialog();
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
            const Row(
              children: [
                /*Text(
                  _selectedDate != null
                      ? DateFormat(DateFormatString).format(_selectedDate! as DateTime)
                      : "-- / -- / ---- ",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: Dimensions.smallTextSize,
                  ),
                ),*/
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