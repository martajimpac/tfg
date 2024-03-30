import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_textfield.dart';

import '../components/custom_drop_down_field.dart';
import '../main.dart';


class FiltrosPage extends StatefulWidget {
  const FiltrosPage({Key? key}) : super(key: key);

  @override
  _FiltrosPageState createState() => _FiltrosPageState();
}

class _FiltrosPageState extends State<FiltrosPage> {
  late DateTime _selectedDate;
  late TextEditingController _descripcionController;
  late List<dynamic> data = [];

  final dropDownController = TextEditingController();
  String _currentDropDownSelectedValue = '';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _descripcionController = TextEditingController();
    getData();
  }

  Future<List<dynamic>> getDataFromTable(String tableName) async {
    final response = await supabase.from(tableName).select();
    return response;
  }

  Future<void> getData() async {
    data = await getDataFromTable('maq_centro');
    setState(() {});
  }

  List<String> getDropdownValues() {
    return data.map((row) => row['denominacion'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Filtros',
            style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Centro:',
              ),
              CustomDropdownField(
                controller: dropDownController,
                hintText: "Selecciona un centro",
                items: getDropdownValues(),
                numItems: 5,
                onValueChanged: (value) {
                  setState(() {
                    _currentDropDownSelectedValue = value;
                  });
                },
              ),
              const Text(
                'Fecha:',
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  _showDatePicker(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Descripción:',
              ),
              const SizedBox(height: 8),
              MyTextField(controller: _descripcionController, hintText: "Ingrese la descripcion"),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose(); // Limpia el controlador del campo de texto
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: FiltrosPage(),
  ));
}
