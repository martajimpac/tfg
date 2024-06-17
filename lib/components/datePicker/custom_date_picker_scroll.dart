import 'package:evaluacionmaquinas/utils/ConstantsHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../theme/dimensions.dart';

class CustomDatePickerScroll extends StatefulWidget {
  final Function(DateTime) onDateChanged;
  final DateTime initialDate;

  const CustomDatePickerScroll({
    Key? key,
    required this.onDateChanged,
    required this.initialDate, // Agregar el parámetro de fecha inicial
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePickerScroll> {
  late DateTime _selectedDate;
  late final DateTime _minumunDate =  DateTime.now().add(const Duration(days: 1)); //fecha minima, la fecha de hoy mas 1 día
  bool _showDatePicker = false;

  @override
  void initState() {
    super.initState();
    // Si la fecha seleccionada no es menor que la calculada la ponemos
    if(widget.initialDate.isAfter(DateTime.now())){
      _selectedDate = widget.initialDate;
    }else{
      _selectedDate = _minumunDate;
    }

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
                child: _showDatePicker ? const Text('Guardar', style: TextStyle(color: Colors.red),) : const Text('Cambiar'),
                onTap: () {
                  setState(() {
                    if(_showDatePicker){
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
            initialDateTime: _selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              _selectedDate = newDate;
              },
            use24hFormat: true,
            //minimumYear: widget.initialDate.year - 2,
            maximumYear: ConstantsHelper.calculateDate(context, 10).year, //máximo 10 años
            minimumDate: _minumunDate,
            mode: CupertinoDatePickerMode.date,
          )
              : null,
        ),
      ],
    );
  }
}
