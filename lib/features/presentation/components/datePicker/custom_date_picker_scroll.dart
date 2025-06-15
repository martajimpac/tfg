import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../core/utils/Constants.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../generated/l10n.dart';

class CustomDatePickerScroll extends StatefulWidget {
  final Function(DateTime) onDateChanged;
  final DateTime initialDate;

  const CustomDatePickerScroll({
    super.key,
    required this.onDateChanged,
    required this.initialDate,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePickerScroll> {
  late DateTime _selectedDate;
  // Fecha mínima para el selector (mañana a medianoche)
  late final DateTime _pickerMinimumDate;
  bool _showDatePicker = false;

  DateTime _normalizeDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    // Establece la fecha mínima seleccionable como mañana a medianoche
    _pickerMinimumDate = _normalizeDate(now.add(const Duration(days: 1)));

    // Normaliza la fecha inicial proporcionada
    DateTime normalizedInitialDate = _normalizeDate(widget.initialDate);

    // Si la initialDate (normalizada) es anterior a la mínima permitida por el picker,
    // entonces _selectedDate será la mínima permitida.
    // De lo contrario, _selectedDate será la initialDate (normalizada).
    if (normalizedInitialDate.isBefore(_pickerMinimumDate)) {
      _selectedDate = _pickerMinimumDate;
    } else {
      _selectedDate = normalizedInitialDate;
    }

    // Notificar al widget padre de la fecha inicial efectiva después de la construcción del frame
    // Esto es importante si la initialDate fue ajustada.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { // Siempre buena práctica verificar si el widget sigue montado
        widget.onDateChanged(_selectedDate);
      }
    });
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
            horizontal: Dimensions.marginSmall,
            vertical: Dimensions.marginSmall,
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
                child: _showDatePicker
                    ? Text(
                  S.of(context).save,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer),
                )
                    : Text(S.of(context).modify),
                onTap: () {
                  setState(() {
                    if (_showDatePicker) {
                      // Cuando se guarda, la _selectedDate ya ha sido validada por el CupertinoDatePicker
                      // y su propiedad onDateTimeChanged.
                      widget.onDateChanged(_selectedDate);
                    }
                    _showDatePicker = !_showDatePicker;
                  });
                },
              )
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showDatePicker ? MediaQuery.of(context).size.height / 3 : 0,
          child: _showDatePicker
              ? CupertinoDatePicker(
            initialDateTime: _selectedDate, // Ya está validada para ser >= _pickerMinimumDate
            onDateTimeChanged: (DateTime newDate) {
              // CupertinoDatePicker ya respeta minimumDate, así que newDate siempre será válida.
              // Solo necesitamos actualizar el estado si realmente cambia para evitar reconstrucciones innecesarias.
              // No es necesario normalizar aquí ya que el picker devuelve solo fecha en modo date.
              if (_selectedDate != newDate) {
                setState(() { // Necesitas setState aquí para que el texto del DateFormat se actualice mientras eliges
                  _selectedDate = newDate;
                });
              }
            },
            use24hFormat: true,
            maximumYear: Utils.calculateDate(context, 10).year,
            minimumDate: _pickerMinimumDate, // Esta es la clave para la validación en el picker
            mode: CupertinoDatePickerMode.date,
          )
              : null,
        ),
      ],
    );
  }
}