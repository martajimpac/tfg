import 'package:flutter/material.dart';

class DateSlider extends StatefulWidget {
  final ValueChanged<DateTime> onChanged;
  final DateTime initialDate;

  const DateSlider({
    Key? key,
    required this.onChanged,
    required this.initialDate,
  }) : super(key: key);

  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  late double _sliderValue;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Calcula el valor inicial del slider basado en la fecha inicial proporcionada
    _selectedDate = widget.initialDate;
    _sliderValue = _calculateSliderValue(_selectedDate);
  }

  // Calcula el valor del slider basado en la diferencia entre la fecha seleccionada y la fecha inicial
  double _calculateSliderValue(DateTime date) {
    final initialDifference = date.difference(widget.initialDate).inDays;
    final maxDifference = DateTime(date.year + 2, date.month, date.day)
        .difference(widget.initialDate)
        .inDays;
    return initialDifference.toDouble() / maxDifference.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _sliderValue,
          onChanged: (newValue) {
            setState(() {
              _sliderValue = newValue;
              final maxDifference = DateTime(_selectedDate.year + 2, _selectedDate.month, _selectedDate.day)
                  .difference(widget.initialDate)
                  .inDays;
              final newDate = widget.initialDate.add(Duration(days: (newValue * maxDifference).toInt()));
              _selectedDate = newDate;
              widget.onChanged(newDate);
            });
          },
        ),
        Text(
          'Fecha de caducidad: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}