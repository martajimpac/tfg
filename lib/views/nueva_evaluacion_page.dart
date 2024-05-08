import 'dart:async';
import 'dart:typed_data';

import 'package:evaluacionmaquinas/components/dialog/my_loading_dialog.dart';
import 'package:evaluacionmaquinas/components/dialog/my_select_photo_dialog.dart';
import 'package:evaluacionmaquinas/cubit/evaluaciones_cubit.dart';
import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/components/textField/my_textfield.dart';
import 'package:evaluacionmaquinas/modelos/centro_dm.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/checklist_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:intl/intl.dart';

import '../components/datePicker/custom_date_picker.dart';
import '../components/datePicker/custom_date_picker_scroll.dart';
import '../components/textField/custom_drop_down_field.dart';

import 'package:flutter/material.dart';

import '../components/dialog/my_content_dialog.dart';
import '../components/dialog/my_ok_dialog.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import '../cubit/centros_cubit.dart';
import '../cubit/insertar_evaluacion_cubit.dart';

class NuevaEvaluacionPage extends StatefulWidget {
  const NuevaEvaluacionPage({Key? key}) : super(key: key);

  @override
  _NuevaEvaluacionPageState createState() => _NuevaEvaluacionPageState();


}

class _NuevaEvaluacionPageState extends State<NuevaEvaluacionPage> {
  late InsertarEvaluacionCubit _cubitInsertarEvaluacion;
  late Timer _timer;

  final _centrosController = TextEditingController();
  final _denominacionController = TextEditingController();
  final _fabricanteController = TextEditingController();
  final _numeroSerieController = TextEditingController();

  List<CentroDataModel> _centros = [];

  //valores evaluacion
  int? _idCentro;
  String _nombreCentro = "";
  final List<Uint8List> _imageList = [];
  late DateTime _fechaCaducidad;
  DateTime? _fechaFabricacion;
  DateTime? _fechaPuestaServicio;

  bool _isCentroRed = false;
  bool _isNombreMaquinaRed = false;
  bool _isNumeroSerieRed = false;

  void _checkImageLimit() {
    if(_imageList.length >= 3){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyOkDialog(
            title: 'Límite de imágenes alcanzado.',
            desc: 'No es posible subir más de tres imágenes.',
            onTap: (){Navigator.of(context).pop(); },
          );
        },
      );
    }else{
      _getImage();
    }
  }

  void _showDialogCheck(BuildContext context) {
    _nombreCentro = _centrosController.text;
    if (_nombreCentro.isNotEmpty) {
      _idCentro = _centros.firstWhere((it) => it.denominacion == _nombreCentro).idCentro;
    } else {
      _idCentro = null;
    }
    if (_idCentro == null || _nombreCentro == "" || _denominacionController.text == "" || _numeroSerieController.text == "") {
      // Lista para almacenar los nombres de los campos que son null
      List<String> camposNull = [];

      setState(() {
        // Verificar cada campo y agregar su nombre a la lista si es null
        if (_idCentro == null || _nombreCentro == "") {
          camposNull.add('Centro');
          _isCentroRed = true;
        }
        if (_denominacionController.text == "") {
          camposNull.add('Denominación');
          _isNombreMaquinaRed = true;
        }
        if (_numeroSerieController.text == "") {
          camposNull.add('Número de serie');
          _isNumeroSerieRed = true;
        }
      });

      // Construir el mensaje de error
      String errorMessage = 'Los siguientes campos son obligatorios y no pueden estar vacíos:\n';
      errorMessage += camposNull.join(', ');

      // Mostrar el diálogo con el mensaje de error
      ConstantsHelper.showMyOkDialog(context, "Error", errorMessage, () =>  Navigator.of(context).pop());
    }else{
      _showResume(context);
    }
  }


  void _showResume(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyContentDialog(
          title:  Text("Resumen", style: Theme.of(context).textTheme.titleMedium),
          content: Container(
              child: Column(
                children: [
                  Text("Datos evaluacion", style: Theme.of(context).textTheme.headlineMedium),
                  Text("Centro: $_nombreCentro"),
                  Text("Fecha de caducidad: ${ DateFormat(DateFormatString).format(_fechaCaducidad) }"),
                  Text("Datos evaluacion", style: Theme.of(context).textTheme.headlineMedium),
                  Text("Denominacion: ${_denominacionController.text}"),
                  Text("Fabricante: ${_fabricanteController.text}"),
                  if (_fechaFabricacion != null) Text("Fecha de fabricación: ${DateFormat(DateFormatString).format(_fechaFabricacion!)}"),
                  if (_fechaPuestaServicio != null) Text("Fecha de puesta en servicio: ${DateFormat(DateFormatString).format(_fechaPuestaServicio!)}")
                ],
              )
          ),
          primaryButtonText: "Continuar",
          secondaryButtonText: "Modificar",
          onPrimaryButtonTap: () {
            _insertarEvaluacion();
          },
          onSecondaryButtonTap: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyTwoButtonsDialog(
          title: 'Confirmación',
          desc: '¿Estás seguro de que quieres salir?\nLos datos de la evaluación no se guardaran',
          primaryButtonText: "Aceptar",
          onPrimaryButtonTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()),);
          },
          secondaryButtonText: "Cancelar",
          onSecondaryButtonTap: (){Navigator.of(context).pop(); },
        );
      },
    );
  }

  Future<void> _insertarEvaluacion() async {
    _cubitInsertarEvaluacion.insertarEvaluacion(
        1, //idinspector (de supabase)
        _idCentro!,
        1, //idtipoeval
        DateTime.now(),
        _fechaCaducidad,
        _fechaFabricacion,
        _fechaPuestaServicio,
        _denominacionController.text,
        _fabricanteController.text,
        _numeroSerieController.text,
        _imageList
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CentrosCubit>(context).getCentros();
    _cubitInsertarEvaluacion = BlocProvider.of<InsertarEvaluacionCubit>(context, listen: false);
    _fechaCaducidad = ConstantsHelper.calculateDate(context, 2);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


    Future<void> _getImage() async {
    // Mostrar un diálogo con opciones
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MySelectPhotoDialog(
          onCameraButtonTap: () async {
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
          onGalleryButtonTap: () async {
            Navigator.pop(context); // Cerrar el diálogo
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              final bytes = await pickedFile.readAsBytes();
              setState(() {
                _imageList.add(bytes);
              });
            }
          }
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop){
          //TODO HACER QUE AL DAR A ACEPTAR SALGA DE LA APP
          _showExitDialog(context);
          //GoRouter.of(context).go('/home');
        }, child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0), // Ajusta el espacio vertical según sea necesario
            child: Row(
              children: [
                Image.asset(
                  'lib/images/ic_maq.png',
                  height: 60, // Ajusta el tamaño de la imagen según sea necesario
                  width: 60,
                ),
                Text(
                  'Crea una nueva evaluación',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close), // Icono de cruz
              onPressed: () {
                _showExitDialog(context);
                //GoRouter.of(context).go('/home');
              },
            ),
          ],
        ),

        body: Padding(
        padding: const EdgeInsets.all(Dimensions.marginSmall), // Puedes ajustar los valores según sea necesario
        child:Column(
          children: [
            const SizedBox(height: Dimensions.marginMedium),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  /**********************DATOS EVALUACION***********************/
                  Text("Datos evaluacion", style: Theme.of(context).textTheme.headlineMedium,),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("*Centro"),
                  BlocBuilder<CentrosCubit, CentrosState>(
                    builder: (context, state) {
                      if (state is CentrosLoading) {
                        List<CentroDataModel> centros = [];
                        return CustomDropdownField(
                          controller: _centrosController,
                          hintText: "Nombre del centro",
                          items: centros,
                          numItems: 0,
                          onValueChanged: (value) {},
                        );
                      } else if (state is CentrosLoaded) {
                        _centros = state.centros;

                        return CustomDropdownField(
                          controller: _centrosController,
                          hintText: "Nombre del centro",
                          items: _centros,
                          numItems: 5,
                          onValueChanged: (value) {
                          },
                          isRed: _isCentroRed,
                        );
                      } else if (state is CentrosError) {
                          ConstantsHelper.showMyOkDialog(context, "Error", state.errorMessage, () => null);
                          return const SizedBox();
                      } else {  return const SizedBox(); }
                    },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("*Fecha de caducidad"),
                  CustomDatePickerScroll(
                    initialDate: _fechaCaducidad,
                    onDateChanged: (DateTime newDate) {
                      _fechaCaducidad = newDate;
                      _timer.cancel(); //TODO NO SE PORQUE ESTO NO FUNCIONA
                      _timer = Timer(const Duration(seconds: 1), () {
                        Fluttertoast.showToast(
                          msg:  ConstantsHelper.getDifferenceBetweenDates(context, DateTime.now(), _fechaCaducidad),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                        );
                      });
                    },
                  ),

                  /********************** DATOS MAQUINA***********************/
                  const SizedBox(height: Dimensions.marginBig),
                  Text("Datos de la máquina", style: Theme.of(context).textTheme.headlineMedium),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("*Denominación"),
                  MyTextField(controller: _denominacionController, hintText: "Nombre de la máquina", isRed: _isNombreMaquinaRed),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("Fabricante"),
                  MyTextField(controller: _fabricanteController, hintText: "Nombre del fabricante"),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("*Nº de fabricante / Nº de serie"),
                  MyTextField(controller: _numeroSerieController, hintText: "Número", isRed: _isNumeroSerieRed,),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("Fecha de fabricación"),
                  CustomDatePicker(
                    onDateChanged: (DateTime newDate) {
                      _fechaFabricacion = newDate;
                    },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("Fecha de puesta en servicio"),

                  const SizedBox(height: Dimensions.marginSmall),
                  CustomDatePicker(
                    onDateChanged: (DateTime newDate) {
                      _fechaPuestaServicio = newDate;
                    },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Visibility(
                    visible: _imageList.isEmpty,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: _checkImageLimit,
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
                    height: _imageList.isNotEmpty ? 200 : 0, // Ajusta la altura según lo necesites
                    child: _imageList.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _imageList.length + 1, // +1 para el botón "más"
                      itemBuilder: (BuildContext context, int index) {
                        if (index == _imageList.length) {
                          // Último ítem, mostrar el botón "más"
                          return GestureDetector(
                            onTap: () {
                              _checkImageLimit();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.add,
                                color: Colors.grey[600],
                                size: 48.0,
                              ),
                            ),
                          );
                        } else {
                          // Mostrar la imagen con el botón de eliminar
                          return Stack(
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
                              Positioned( //cruz para eliminar las imagenes
                                top: 8.0,
                                right: 8.0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _imageList.removeAt(index);
                                    });
                                  },
                                  child: Image.asset(
                                    'lib/images/ic_close.png',
                                    height: 20, // Ajusta el tamaño de la imagen según sea necesario
                                    width: 20,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    )
                        : const SizedBox(),
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  MyButton(
                    adaptableWidth: false,
                    onTap: () {
                      _showDialogCheck(context);
                    },
                    text: "Continuar",
                  ),
                  BlocListener<InsertarEvaluacionCubit, InsertarEvaluacionState>(
                      listener: (context, state) {
                        // Aquí puedes escuchar los cambios en el estado del bloc y reaccionar en consecuencia
                        if(state is InsertarEvaluacionLoading){
                          Navigator.of(context).pop(); //cerrar resumen
                          ConstantsHelper.showLoadingDialog(context);
                        }else if(state is EvaluacionInsertada) {
                          // Si la evaluación se inserta con éxito, puedes navegar a la página de checklist
                          Navigator.of(context).pop(); //cerrar cargando
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckListPage()),);
                        }else if(state is InsertarEvaluacionError){
                          Navigator.of(context).pop(); //cerrar cargando
                          ConstantsHelper.showMyOkDialog(context, "Error", state.errorMessage, () {
                            Navigator.of(context).pop();
                          });
                        }
                      }, child: SizedBox(),
                  )
                ],
              ),
            ),
          ],
      ),
    )
    )
    );
  }
}


