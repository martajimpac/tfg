import 'dart:async';

import 'package:evaluacionmaquinas/components/dialog/my_loading_dialog.dart';
import 'package:evaluacionmaquinas/components/dialog/my_select_photo_dialog.dart';
import 'package:evaluacionmaquinas/cubit/evaluaciones_cubit.dart';
import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/imagen_dm.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../components/datePicker/custom_date_picker.dart';
import '../components/datePicker/custom_date_picker_scroll.dart';
import '../components/textField/custom_drop_down_field.dart';

import 'package:flutter/material.dart';

import '../components/dialog/my_content_dialog.dart';
import '../components/dialog/my_ok_dialog.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import '../cubit/centros_cubit.dart';
import '../cubit/eliminar_evaluacion_cubit.dart';
import '../cubit/insertar_evaluacion_cubit.dart';

class NuevaEvaluacionPage extends StatefulWidget {
  final EvaluacionDetailsDataModel? evaluacion;
  final List<ImagenDataModel>? imagenes;

  const NuevaEvaluacionPage({Key? key, this.evaluacion, this.imagenes}) : super(key: key);

  @override
  _NuevaEvaluacionPageState createState() => _NuevaEvaluacionPageState();
}

class _NuevaEvaluacionPageState extends State<NuevaEvaluacionPage> {
  late InsertarEvaluacionCubit _cubitInsertarEvaluacion;
  late EliminarEvaluacionCubit _cubitEliminarEvaluacion;
  bool _isModifiying = false;

  final _centrosController = TextEditingController();
  final _denominacionController = TextEditingController();
  final _fabricanteController = TextEditingController();
  final _numeroSerieController = TextEditingController();

  List<CentroDataModel> _centros = [];

  //valores evaluacion
  int? _idEvaluacion;
  int? _idMaquina;

  int? _idCentro;
  String _nombreCentro = "";
  final List<Uint8List> _imageList = [];
  late DateTime _fechaCaducidad;
  DateTime? _fechaFabricacion;
  DateTime? _fechaPuestaServicio;
  final _fechaFabricacionNotifier = ValueNotifier<DateTime?>(null);
  final _fechaPuestaServicioNotifier = ValueNotifier<DateTime?>(null);

  bool _isFechasRed = false;
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
            onTap: (){ Navigator.of(context).pop(); },
          );
        },
      );
    }else{
      _getImage();
    }
  }

  void _showDialogCheck(BuildContext context) {
    _nombreCentro = _centrosController.text.trim();

    if (_nombreCentro.isNotEmpty) {
      try{
        _idCentro = _centros.firstWhere((it) => it.denominacion == _nombreCentro).idCentro;
      }catch(e){
        _idCentro = -1;
      }

    } else {
      _idCentro = null;
    }
    debugPrint("$_idCentro");

    if (_idCentro == null  || _nombreCentro == "" || _denominacionController.text.trim() == "" || _numeroSerieController.text.trim() == "") {
      // Lista para almacenar los nombres de los campos que son null
      List<String> camposNull = [];

      setState(() {
        // Verificar cada campo y agregar su nombre a la lista si es null
        if (_idCentro == null || _nombreCentro == "") {
          camposNull.add('Centro');
          _isCentroRed = true;
        }
        if (_denominacionController.text.trim() == "") {
          camposNull.add('Denominación');
          _isNombreMaquinaRed = true;
        }
        if (_numeroSerieController.text.trim() == "") {
          camposNull.add('Nº de fabricante / Nº de serie');
          _isNumeroSerieRed = true;
        }
      });

      // Construir el mensaje de error
      String errorMessage = 'Los siguientes campos son obligatorios y no pueden estar vacíos:\n\n';
      errorMessage += camposNull.join('\n');

      // Mostrar el diálogo con el mensaje de error
      ConstantsHelper.showMyOkDialog(context, "Error", errorMessage, () =>  Navigator.of(context).pop());
    }else if(_idCentro == -1){
      setState(() {
        _isFechasRed = false;
        _isCentroRed = true;
        _isNumeroSerieRed = false;
        _isNumeroSerieRed = false;
      });

      String errorMessage = 'El centro introducido debe coincidir con uno de los de la lista de centros disponibles';

      // Mostrar el diálogo con el mensaje de error
      ConstantsHelper.showMyOkDialog(context, "Error", errorMessage, () =>  Navigator.of(context).pop());
    } else if(_fechaFabricacion != null && _fechaPuestaServicio != null){

      if(_fechaFabricacion!.isBefore(_fechaPuestaServicio!)){
        _showResume(context);
      }else{
        setState(() {
          _isFechasRed = true;
          _isCentroRed = false;
          _isNumeroSerieRed = false;
          _isNumeroSerieRed = false;
        });

        // Mostrar el diálogo con el mensaje de error
        ConstantsHelper.showMyOkDialog(context, "Error", "La fecha de puesta en servicio no puede ser anterior a la fecha de fabricación", () =>  Navigator.of(context).pop());
      }

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
                  if(_fabricanteController.text.trim().isNotEmpty) Text("Fabricante: ${_fabricanteController.text}"),
                  Text("Nº de fabricante / Nº de serie: ${_numeroSerieController.text}"),
                  if (_fechaFabricacion != null) Text("Fecha de fabricación: ${DateFormat(DateFormatString).format(_fechaFabricacion!)}"),
                  if (_fechaPuestaServicio != null) Text("Fecha de puesta en servicio: ${DateFormat(DateFormatString).format(_fechaPuestaServicio!)}")
                ],
              )
          ),
          primaryButtonText: "Continuar",
          secondaryButtonText: "Modificar",
          onPrimaryButtonTap: () {
            if(_isModifiying){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckListPage()),); //_modificarEvaluacion();
            }else{
              _insertarEvaluacion();
            }
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
          desc: '¿Está seguro de que quiere salir?\nLos datos de la evaluación no se guardarán.',
          primaryButtonText: "Salir",
          onPrimaryButtonTap: () {
            if(_idEvaluacion != null && _idMaquina != null){
              //si ya habiamos insertado la evaluacion (habiamos pasado al checklist y hemos vuelto) la eliminamos
              Navigator.of(context).pop();
              _cubitEliminarEvaluacion.eliminarEvaluacion(_idEvaluacion!, _idMaquina!);
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
            }
          },
          secondaryButtonText: "Cancelar",
          onSecondaryButtonTap: (){Navigator.of(context).pop(); },
        );
      },
    );
  }

  Future<void> _modificarEvaluacion() async {
    /*_cubitInsertarEvaluacion.insertarEvaluacion(
        1, //idinspector (de supabase)
        _idCentro!,
        1, //idtipoeval
        DateTime.now(),
        _fechaCaducidad,
        _fechaFabricacion,
        _fechaPuestaServicio,
        _denominacionController.text.trim(),
        _fabricanteController.text.trim(),
        _numeroSerieController.text.trim(),
        _imageList
    );*/
  }

  Future<void> _insertarEvaluacion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id =  prefs.getString('id') ?? '';
    _cubitInsertarEvaluacion.insertarEvaluacion(
        id, //idinspector (de supabase)
        _idCentro!,
        1, //idtipoeval
        DateTime.now(),
        _fechaCaducidad,
        _fechaFabricacion,
        _fechaPuestaServicio,
        _denominacionController.text.trim(),
        _fabricanteController.text.trim(),
        _numeroSerieController.text.trim(),
        _imageList
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CentrosCubit>(context).getCentros();
    _cubitInsertarEvaluacion = BlocProvider.of<InsertarEvaluacionCubit>(context, listen: false);
    _cubitEliminarEvaluacion = BlocProvider.of<EliminarEvaluacionCubit>(context);
    _fechaCaducidad = ConstantsHelper.calculateDate(context, 2);

    if(widget.evaluacion != null){
      _isModifiying = true;

      if(widget.evaluacion!.nombreCentro.isNotEmpty){
        _centrosController.text = widget.evaluacion!.nombreCentro;
      }
      _fechaCaducidad = widget.evaluacion!.fechaCaducidad;

      if(widget.evaluacion!.fechaFabricacion != null){
        _fechaFabricacionNotifier.value = widget.evaluacion!.fechaFabricacion;
      }
      if(widget.evaluacion!.fechaPuestaServicio != null){
        _fechaPuestaServicioNotifier.value = widget.evaluacion!.fechaPuestaServicio;
      }
      if(widget.evaluacion!.nombreMaquina.isNotEmpty){
        _denominacionController.text = widget.evaluacion!.nombreMaquina;
      }
      if(widget.evaluacion!.fabricante != null && widget.evaluacion!.fabricante!.isNotEmpty){
        _fabricanteController.text = widget.evaluacion!.fabricante!;
      }
      if(widget.evaluacion!.numeroSerie.isNotEmpty){
        _numeroSerieController.text = widget.evaluacion!.numeroSerie;
      }
    }

    if (widget.imagenes != null && widget.imagenes!.isNotEmpty) {
      _imageList.addAll(widget.imagenes!.map((imagen) => imagen.imagen));
    }
  }

  @override
  void dispose() {
    _centrosController.dispose();
    _denominacionController.dispose();
    _fabricanteController.dispose();
    _numeroSerieController.dispose();
    _fechaFabricacionNotifier.dispose();
    _fechaPuestaServicioNotifier.dispose();
    _centrosController.dispose();

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
          _showExitDialog(context);
          //GoRouter.of(context).go('/home');
        }, child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0), // Ajusta el espacio vertical según sea necesario
            child: Row(
              children: [
                /*Image.asset(
                  'lib/images/ic_maq.png',
                  height: 60, // Ajusta el tamaño de la imagen según sea necesario
                  width: 60,
                ),*/
                Text(
                  'Crea una nueva evaluación',
                   style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.titleTextSize,
                        fontWeight: FontWeight.bold
                    ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white), // Icono de cruz
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Datos de la evaluación", style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("*Centro"),
                  BlocBuilder<CentrosCubit, CentrosState>( //TODO VER ERROR
                    builder: (context, state) {
                      if (state is CentrosLoading) {
                        return const SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is CentrosLoaded) {
                        _centros = state.centros;

                        return CustomDropdownField(
                          controller: _centrosController,
                          hintText: "Nombre del centro",
                          items: _centros,
                          numItems: 5,
                          isRed: _isCentroRed,
                        );
                      } else if (state is CentrosError) {
                        return SizedBox(
                          height: 100,
                          child: Center(child: Text("Error: ${state.errorMessage}")),
                        );
                      } else {  return const SizedBox(); }
                    },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("*Fecha de caducidad"),
                  CustomDatePickerScroll(
                    onDateChanged: (DateTime newDate) {
                      _fechaCaducidad = newDate;
                      Fluttertoast.showToast(
                        msg:  ConstantsHelper.getDifferenceBetweenDates(context, DateTime.now(), _fechaCaducidad),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                      );
                    },
                    initialDate: _fechaCaducidad,
                  ),

                  /********************** DATOS MAQUINA***********************/
                  const SizedBox(height: Dimensions.marginBig),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Datos de la máquina", style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),

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
                    onDateChanged: (DateTime? newDate) {
                      _fechaFabricacion = newDate;
                    },
                    selectedDateNotifier: _fechaFabricacionNotifier,
                    isRed: _isFechasRed,
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("Fecha de puesta en servicio"),

                  const SizedBox(height: Dimensions.marginSmall),
                  CustomDatePicker(
                    onDateChanged: (DateTime? newDate) {
                      _fechaPuestaServicio = newDate;
                    },
                    selectedDateNotifier: _fechaPuestaServicioNotifier,
                    isRed: _isFechasRed,
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Visibility(
                    visible: _imageList.isEmpty,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
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
                                top: 16.0,
                                right: 16.0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _imageList.removeAt(index);
                                    });
                                  },
                                  child: Image.asset(
                                    'lib/images/ic_close.png',
                                    height: 25, // Ajusta el tamaño de la imagen según sea necesario
                                    width: 25,
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
                      _isNumeroSerieRed = false;
                      _isCentroRed = false;
                      _isFechasRed = false;
                      _isNombreMaquinaRed = false;
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
                          _isModifiying = true;
                          _idEvaluacion = state.idEvaluacion;
                          _idMaquina = state.idMaquina;
                          // Si la evaluación se inserta con éxito, puedes navegar a la página de checklist
                          Navigator.of(context).pop(); //cerrar cargando
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckListPage()),);
                        }else if(state is InsertarEvaluacionError){
                          Navigator.of(context).pop(); //cerrar cargando
                          ConstantsHelper.showMyOkDialog(context, "Error", state.errorMessage, () {
                            Navigator.of(context).pop();
                          });
                        }
                      }, child: const SizedBox(),
                  ),
                  BlocListener<EliminarEvaluacionCubit, EliminarEvaluacionState>(
                      listener: (context, state) {
                        if(state is EliminarEvaluacionCompletada){
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                        }else if (state is EliminarEvaluacionLoading) {
                          ConstantsHelper.showLoadingDialog(context);
                        } else if (state is EliminarEvaluacionError) {
                          Navigator.of(context).pop();
                          ConstantsHelper.showMyOkDialog(context, "Error", state.errorMessage, () {
                            Navigator.of(context).pop();
                          });
                        } else {}
                      },child: const SizedBox()
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


