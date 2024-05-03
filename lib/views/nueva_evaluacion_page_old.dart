import 'dart:typed_data';

import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/components/my_textfield.dart';
import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:evaluacionmaquinas/main.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/checklist_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';

import '../components/custom_drop_down_field.dart';

class NuevaEvaluacionPageOld extends StatefulWidget {
  const NuevaEvaluacionPageOld({Key? key}) : super(key: key);

  @override
  _NuevaEvaluacionPageStateOld createState() => _NuevaEvaluacionPageStateOld();
}

class _NuevaEvaluacionPageStateOld extends State<NuevaEvaluacionPageOld> {
  late List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    //getData();
  }

/*  Future<List<dynamic>> getDataFromTable(String tableName) async {
    final response = await supabase.from(tableName).select();
    return response;
  }*/

/*
  Future<void> getData() async {
    data = await getDataFromTable('maq_centro');
    setState(() {});
  }
*/

 /* List<String> getDropdownValues() {
    return data.map((row) => row['denominacion'].toString()).toList();
  }
*/
  final dropDownController = TextEditingController();
  final controller = TextEditingController();
  String _currentDropDownSelectedValue = '';

  //final _responseStream = supabase.from('maq_imagenes').stream(primaryKey: ['idimg']);

  final List<Uint8List> _imageList = [];
  /*Future<List<dynamic>> getListCenters(String tableName) async {
    final response = await supabase.from(tableName).select();
    return response;
  }*/
/*  Future<void> _getImage() async {
    // Mostrar un diálogo con opciones
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seleccionar fuente de imagen"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Cerrar el diálogo
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    setState(() {
                      _imageList.add(bytes);
                    });
                  }
                },
                child: Text("Tomar foto"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Cerrar el diálogo
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    setState(() {
                      _imageList.add(bytes);
                    });
                  }
                },
                child: Text("Seleccionar de galería"),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _saveImages() async {
    // Guardar los bytes de la imagen en la base de datos Supabase
    for (var image in _imageList){
      final response = await supabase.from("maq_imagenes").insert({"ideval": 2,"imagen": image});
      if (response.error != null) {
        // Manejar el error, por ejemplo, mostrando un mensaje al usuario
        debugPrint("Error al guardar la imagen: ${response.error!.message}");
      } else {
        // La imagen se guardó correctamente
        debugPrint("Imagen guardada correctamente en la base de datos.");
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()),);
          //GoRouter.of(context).go('/home');
      }, child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar:  AppBar(
          title: Text(
            'Datos de la inspeccion',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          leading: IconButton(
            icon: const Icon(Icons.close), // Icono de cruz
            onPressed: () {
              GoRouter.of(context).go('/home');
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.marginMedium),
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).drawerTheme!.backgroundColor,
                  borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: Dimensions.marginSmall),
                    /*Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          Container(height: 200, color: Colors.blue),
                          const Text("Centros"),
                          const SizedBox(height: 20.0,),
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
                          SizedBox(
                            height: 200, // Ajusta la altura según lo necesites
                            child: _imageList.isNotEmpty
                                ? ListView(
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                for (int index = 0; index < _imageList.length; index++)
                                  Stack(
                                    children: [
                                      GestureDetector(
                                        onLongPress: () {
                                          setState(() {
                                            _imageList.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(8.0),
                                          width: 200,
                                          height: 200,
                                          child: Image.memory(
                                            _imageList[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8.0,
                                        right: 8.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _imageList.removeAt(index);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            )
                                : const Center(child: Text('No hay imagen seleccionada')),
                          ),
                          MyButton(adaptableWidth: true, onTap:  _getImage, text: 'Seleccionar imagen')
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
            MyButton(
              adaptableWidth: true,
              onTap: () async {
                final BuildContext currentContext = context; // Almacena el contexto antes de entrar en el bloque asincrónico
                //await _saveImages();
                GoRouter.of(context).go('/checklist');
              },
              text: "ir a checklist",
            ),
          ],
        ),
      )
    );
  }
}
