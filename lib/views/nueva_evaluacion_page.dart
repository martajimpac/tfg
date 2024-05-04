import 'dart:typed_data';

import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:evaluacionmaquinas/components/custom_date_picker.dart';
import 'package:evaluacionmaquinas/components/my_subtitle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/components/date_slider.dart';
import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/components/my_loading_dialog.dart';
import 'package:evaluacionmaquinas/components/my_textfield.dart';
import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:evaluacionmaquinas/main.dart';
import 'package:evaluacionmaquinas/modelos/centro_dm.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/checklist_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';

import '../components/custom_drop_down_field.dart';

import 'package:flutter/material.dart';

import '../cubit/centros_cubit.dart';
import '../cubit/insertar_evaluacion_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../modelos/evaluacion_to_insert_dm.dart';
import '../theme/app_theme.dart';

class NuevaEvaluacionPage extends StatefulWidget {
  const NuevaEvaluacionPage({Key? key}) : super(key: key);

  @override
  _NuevaEvaluacionPageState createState() => _NuevaEvaluacionPageState();


}

class _NuevaEvaluacionPageState extends State<NuevaEvaluacionPage> {
  late InsertarEvaluacionCubit _cubitEvaluacion;

  final dropDownController = TextEditingController();
  final denominacionController = TextEditingController();
  final fabricanteController = TextEditingController();
  final numeroSerieController = TextEditingController();

  //valores evaluacion
  late int _idCentro;
  final List<Uint8List> _imageList = [];
  late DateTime _fechaCaducidad;
  late DateTime _fechaRealizacion;
  late DateTime _fechaPuestaEscena;
  late String? _fabricante;
  late int _nombreMaquina;
  late int _numeroSerie;

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _checkImageLimit() {
    if(_imageList.length >= 3){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Límite de imágenes alcanzado.'),
            content: Text('No es posible subir más de tres imágenes.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showDialogCheck(BuildContext context) {
    if(_idCentro == null || _nombreMaquina == null || _numeroSerie == null){ //TODO NO PUEDE SER NULL
      showDialog( //TODO MARCAR EN ROJO CAMPOS QUE FALTAN
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text("errorMessage"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }else{
      _insertarEvaluacion();
    }
  }

  Future<void> _insertarEvaluacion() async {
    final evaluacion = EvaluacionToInsertDataModel.fromRealizacion(
      idinspector: 1,
      idcentro: _idCentro,
      fechaRealizacion: DateTime.now(),
      fechaCaducidad: _fechaCaducidad,//TODO METER AQUI VALOR POR DEFECTO FECHA CADUCIDAD por defecto 2 años, si no selecciona fecha...
      idmaquina: 1, //TODO METER LISTA DE MAQUINAS
      idtipoeval: 1 //todo que significa esto??
    );
    _cubitEvaluacion.insertarEvaluacion(evaluacion, _imageList);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CentrosCubit>(context).getCentros();
    _cubitEvaluacion = BlocProvider.of<InsertarEvaluacionCubit>(context, listen: false);
  }

    Future<void> _getImage() async {
    _checkImageLimit();
    // Mostrar un diálogo con opciones
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Seleccionar fuente de imagen"),
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


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()),);
          //GoRouter.of(context).go('/home'); //TODO
        }, child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Crea una nueva evaluación',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          leading: IconButton(
            icon: Icon(Icons.close), // Icono de cruz
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()),);
              //GoRouter.of(context).go('/home');
            },
          )
        ),

        body: Padding(
        padding: const EdgeInsets.all(Dimensions.marginMedium), // Puedes ajustar los valores según sea necesario
        child:Column(
          children: [
            const SizedBox(height: Dimensions.marginSmall),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  /**********************DATOS EVALUACION***********************/
                  const MySubtitle(text: "Datos evaluacion"),
                  const Text("Selecciona un centro"),
                  const SizedBox(height: 20.0,),
                  BlocBuilder<CentrosCubit, CentrosState>(
                    builder: (context, state) {
                      if (state is CentrosLoading) {
                        List<CentroDataModel> centros = [];
                        return CustomDropdownField(
                          controller: dropDownController,
                          hintText: "Nombre del centro",
                          items: centros,
                          numItems: 0,
                          onValueChanged: (value) {},
                        );
                      } else if (state is CentrosLoaded) {
                        final List<CentroDataModel> centros = state.centros;

                        return CustomDropdownField(
                          controller: dropDownController,
                          hintText: "Nombre del centro",
                          items: centros,
                          numItems: 5,
                          onValueChanged: (value) {
                            setState(() {
                              _idCentro = (value as CentroDataModel).idCentro;
                            });
                          },
                        );
                      } else if (state is CentrosError) {
                          _showErrorDialog(context, state.errorMessage);
                          return SizedBox();
                      } else {  return SizedBox(); }
                    },
                  ),
                  /*DateSlider(
                    initialDate: DateTime.now(), // Fecha inicial para el slider
                    onChanged: (newDate) {
                      setState(() {
                        _fechaCaducidad = newDate; // Actualiza la fecha de caducidad cuando cambia el slider
                      });
                    },
                  ),*/
                  CustomDatePicker(
                    initialDate: DateTime.now(),
                    onDateChanged: (DateTime newDate) {
                    },
                  ),

                  /********************** DATOS MAQUINA***********************/
                  const MySubtitle(text: "Datos de la máquina"),
                  const Text("*Denominación"),
                  MyTextField(controller: denominacionController, hintText: "Nombre de la máquina"),
                  const Text("Fabricante"),
                  MyTextField(controller: fabricanteController, hintText: "Nombre del fabricante"),
                  const Text("*Nª de fabricante / Nº de serie"),
                  MyTextField(controller: numeroSerieController, hintText: "Número"),
                  const Text("Fecha de fabricación"),
                  const Text("Fecha de puesta en servicio"),
                  Visibility(
                    visible: _imageList.isEmpty,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: _getImage,
                            color: Colors.grey,
                          ),
                          const Text(
                            'Añadir imagen',
                            style: TextStyle(
                              fontSize: Dimensions.smallTextSize,
                              color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    )
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
                ],
              ),
            ),
            MyButton(
              adaptableWidth: true,
              onTap: () {
                //TODO COMPROBAR SI DATOS ESTAN SELECCIONADOS
                _showDialogCheck(context);
              },
              text: "ir a checklist",
            ),
            BlocConsumer<InsertarEvaluacionCubit, EvaluacionState>(
                listener: (context, state) {
                  // Aquí puedes escuchar los cambios en el estado del bloc y reaccionar en consecuencia
                  if (state is EvaluacionInsertada) {
                    // Si la evaluación se inserta con éxito, puedes navegar a la página de checklist
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckListPage()),);
                  }
                },
                builder: (context, state) {
                  if (state is EvaluacionLoading) {
                    return const LoadingAlertDialog(); //TODO DIALOGO
                  } else if (state is EvaluacionError) {
                    return Text('Error: ${state.errorMessage}');
                  } else {
                    return Text('Estado desconocido del cubit');
                  }
                }
            )
          ],
      ),
    )
    )
    );
  }
}


