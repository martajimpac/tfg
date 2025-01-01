import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/utils/Utils.dart';
import '../../data/shared_prefs.dart';
import '../../../generated/l10n.dart';
import '../../data/models/centro_dm.dart';
import '../../data/models/evaluacion_details_dm.dart';
import '../../data/models/imagen_dm.dart';
import '../components/buttons/my_button.dart';
import '../components/datePicker/custom_date_picker.dart';
import '../components/datePicker/custom_date_picker_scroll.dart';
import '../components/dialog/my_content_dialog.dart';
import '../components/dialog/my_ok_dialog.dart';
import '../components/dialog/my_select_photo_dialog.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import '../components/textField/custom_drop_down_field.dart';
import '../components/textField/my_textfield.dart';
import '../cubit/centros_cubit.dart';
import '../cubit/eliminar_evaluacion_cubit.dart';
import '../cubit/insertar_evaluacion_cubit.dart';
import 'package:image/image.dart' as img;

import '../cubit/preguntas_cubit.dart';
import 'checklist_page.dart';
import 'my_home_page.dart';

class NuevaEvaluacionPage extends StatefulWidget {
  final EvaluacionDetailsDataModel? evaluacion;
  final List<ImagenDataModel>? imagenes;

  const NuevaEvaluacionPage({super.key, this.evaluacion, this.imagenes});

  @override
  _NuevaEvaluacionPageState createState() => _NuevaEvaluacionPageState();
}

class _NuevaEvaluacionPageState extends State<NuevaEvaluacionPage> {
  late InsertarEvaluacionCubit _cubitInsertarEvaluacion;
  late EliminarEvaluacionCubit _cubitEliminarEvaluacion;
  late PreguntasCubit _cubitPreguntas;
  bool _isModifiying = false;
  bool _exit = false;

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
  final List<ImagenDataModel> _imageList = [];
  bool _loadingImage = false;
  late DateTime _fechaRealizacion;
  late DateTime _fechaCaducidad;
  DateTime? _fechaFabricacion;
  DateTime? _fechaPuestaServicio;
  final _fechaFabricacionNotifier = ValueNotifier<DateTime?>(null);
  final _fechaPuestaServicioNotifier = ValueNotifier<DateTime?>(null);

  bool _isFechasRed = false;
  bool _isCentroRed = false;
  bool _isNombreMaquinaRed = false;
  bool _isNumeroSerieRed = false;

  final FocusNode _campoDenominacionFocus = FocusNode();
  final FocusNode _campoFabricanteFocus = FocusNode();
  final FocusNode _campoNumeroSerieFocus = FocusNode();

  void _checkImageLimit() {
    if(_imageList.length >= 3){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyOkDialog(
            title: S.of(context).errorLimitImageTitle,
            desc: S.of(context).errorLimitImageDesc,
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
          camposNull.add(S.of(context).center);
          _isCentroRed = true;
        }
        if (_denominacionController.text.trim() == "") {
          camposNull.add(S.of(context).denomination);
          _isNombreMaquinaRed = true;
        }
        if (_numeroSerieController.text.trim() == "") {
          camposNull.add(S.of(context).serialNumber);
          _isNumeroSerieRed = true;
        }
      });

      // Construir el mensaje de error
      String errorMessage = S.of(context).errorMandatoryFields;
      errorMessage += camposNull.join('\n');

      // Mostrar el diálogo con el mensaje de error
      Utils.showMyOkDialog(context, S.of(context).error, errorMessage, () =>  Navigator.of(context).pop());
    }else if(_idCentro == -1){
      setState(() {
        _isFechasRed = false;
        _isCentroRed = true;
        _isNumeroSerieRed = false;
        _isNumeroSerieRed = false;
      });

      String errorMessage = S.of(context).errorCenterDoesntMatch;

      // Mostrar el diálogo con el mensaje de error
      Utils.showMyOkDialog(context, S.of(context).error, errorMessage, () =>  Navigator.of(context).pop());
    } else if(_fechaFabricacion != null && _fechaPuestaServicio != null){

      if(_fechaFabricacion!.isBefore(_fechaPuestaServicio!) || _fechaFabricacion == _fechaPuestaServicio){
        _showResume(context);
      }else{
        setState(() {
          _isFechasRed = true;
          _isCentroRed = false;
          _isNumeroSerieRed = false;
          _isNumeroSerieRed = false;
        });

        // Mostrar el diálogo con el mensaje de error
        Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorComissioningDate, () =>  Navigator.of(context).pop());
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
          title:  Text(S.of(context).summary, style: Theme.of(context).textTheme.titleMedium),
          content: Container(
              child: Column(
                children: [
                  Text(S.of(context).evaluationData, style: Theme.of(context).textTheme.headlineMedium),
                  Text("${S.of(context).center}: $_nombreCentro"),
                  Text("${S.of(context).expirationDate}: ${ DateFormat(DateFormatString).format(_fechaCaducidad) }"),
                  Text(S.of(context).machineData, style: Theme.of(context).textTheme.headlineMedium),
                  Text("${S.of(context).denomination}: ${_denominacionController.text}"),
                  if(_fabricanteController.text.trim().isNotEmpty) Text("${S.of(context).manufacturer}: ${_fabricanteController.text}"),
                  Text("${S.of(context).serialNumber}: ${_numeroSerieController.text}"),
                  if (_fechaFabricacion != null) Text("${S.of(context).manufacturedDate}: ${DateFormat(DateFormatString).format(_fechaFabricacion!)}"),
                  if (_fechaPuestaServicio != null) Text("${S.of(context).comissioningDate}: ${DateFormat(DateFormatString).format(_fechaPuestaServicio!)}")
                ],
              )
          ),
          primaryButtonText: S.of(context).continuee,
          secondaryButtonText: S.of(context).modify,
          onPrimaryButtonTap: () {
            //Navigator.of(context).pop(); //TODO DA ERROR RARO

            //Pulsamos en el botón "Continuar"
            if(_idEvaluacion != null){
              _modificarEvaluacion();
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
    if(_isModifiying){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyTwoButtonsDialog(
            title: S.of(context).confirmation,
            desc: S.of(context).exitEvaluationChanges,
            primaryButtonText: S.of(context).exit,
            onPrimaryButtonTap: () {
              _cubitPreguntas.deletePreguntas();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
            },
            secondaryButtonText: S.of(context).cancel,
            onSecondaryButtonTap: (){
              Navigator.of(context).pop();
            },
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyTwoButtonsDialog(
            title: S.of(context).confirmation,
            desc: S.of(context).exitEvaluation,
            primaryButtonText: S.of(context).exit,
            onPrimaryButtonTap: () {
              _cubitPreguntas.deletePreguntas();
              if(_idEvaluacion != null && _idMaquina != null){
                //si ya habiamos insertado la evaluacion (habiamos pasado al checklist y hemos vuelto) la eliminamos TODO REVISA ESTO
                _exit = true;

                Navigator.of(context).pop();
                _cubitEliminarEvaluacion.eliminarEvaluacion(context, _idEvaluacion!, _idMaquina!);
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
              }
            },
            secondaryButtonText: S.of(context).cancel,
            onSecondaryButtonTap: (){
              Navigator.of(context).pop();
              },
          );
        },
      );
    }

  }



  Future<void> _insertarEvaluacion() async {
    final id = await SharedPrefs.getUserId();

    _fechaRealizacion = DateTime.now();

    _cubitInsertarEvaluacion.insertarEvaluacion(
        context,
        id, //idinspector (de supabase)
        _idCentro!,
        _nombreCentro,
        1, //idtipoeval
        _fechaRealizacion, //fecha realizacion
        _fechaCaducidad,
        _fechaFabricacion,
        _fechaPuestaServicio,
        _denominacionController.text.trim(),
        _fabricanteController.text.trim(),
        _numeroSerieController.text.trim(),
        _imageList.map((imageModel) => imageModel.imagen!).toList()
    );
  }

  Future<void> _modificarEvaluacion() async {
    final id = await SharedPrefs.getUserId();

    _cubitInsertarEvaluacion.modificarEvaluacion(
        context,
        id,  //idinspector (de supabase)
        _idEvaluacion!,
        _idCentro!,
        _nombreCentro,
        1, //idtipoeval
        _fechaRealizacion,
        DateTime.now(), //fecha modificacion
        _fechaCaducidad,
        _fechaFabricacion,
        _fechaPuestaServicio,
        _idMaquina!,
        _denominacionController.text.trim(),
        _fabricanteController.text.trim(),
        _numeroSerieController.text.trim(),
        _imageList
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CentrosCubit>(context).getCentros(context);
    _cubitInsertarEvaluacion = BlocProvider.of<InsertarEvaluacionCubit>(context, listen: false);
    _cubitEliminarEvaluacion = BlocProvider.of<EliminarEvaluacionCubit>(context);
    _cubitPreguntas = BlocProvider.of<PreguntasCubit>(context);
    _fechaCaducidad = Utils.calculateDate(context, 2);

    if(widget.evaluacion != null){
      _isModifiying = true;

      //cargar los datos de la evaluación
      _idEvaluacion = widget.evaluacion!.ideval;
      _idMaquina = widget.evaluacion!.idmaquina;
      _idCentro = widget.evaluacion!.idcentro;
      if(widget.evaluacion!.nombreCentro.isNotEmpty){
        _centrosController.text = widget.evaluacion!.nombreCentro;
      }
      _fechaRealizacion = widget.evaluacion!.fechaRealizacion;
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
      _imageList.addAll(widget.imagenes!);
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
    _campoDenominacionFocus.dispose();
    _campoFabricanteFocus.dispose();
    _campoNumeroSerieFocus.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MySelectPhotoDialog(
          onCameraButtonTap: () async {
            Navigator.pop(context); // Cerrar el diálogo
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.camera);
            if (pickedFile != null) {
              setState(() {
                _loadingImage = true;
              });
              final compressedImage = await Utils.compressImage(await pickedFile.readAsBytes(), context);
              setState(() {
                _imageList.add(ImagenDataModel(
                  idimg: null,
                  imagen: compressedImage,
                ));
                _loadingImage = false;
              });
            }
          },
          onGalleryButtonTap: () async {
            Navigator.pop(context); // Cerrar el diálogo
            final picker = ImagePicker();

            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                _loadingImage = true;
              });
              final compressedImage = await Utils.compressImage(await pickedFile.readAsBytes(), context);
              setState(() {
                _imageList.add(ImagenDataModel(
                  idimg: null,
                  imagen: compressedImage,
                ));
                _loadingImage = false;
              });
            }else{

            }
          },
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
      backgroundColor: Theme.of(context).colorScheme.surface,

        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          automaticallyImplyLeading: false,
          centerTitle: true, // Esto centra el título
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0), // Ajusta el espacio vertical según sea necesario
            child: Text(
              _isModifiying == true
                  ? S.of(context).modifyEvaluationTitle
                  : S.of(context).newEvaluationTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: Dimensions.titleTextSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Asegura que el texto esté centrado
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white, semanticLabel:  S.of(context).semanticlabelClose), // Icono de cruz
              onPressed: () {
                _showExitDialog(context);
              },
            ),
          ],
        ),


        body: Padding(
        padding: const EdgeInsets.all(Dimensions.marginSmall), // Puedes ajustar los valores según sea necesario
        child: Column(
          children: [
            //const SizedBox(height: Dimensions.marginMedium),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  /**********************DATOS EVALUACION***********************/
                  const SizedBox(height: Dimensions.marginSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).evaluationData, style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Text(S.of(context).centerAsterisk),
                  BlocBuilder<CentrosCubit, CentrosState>(
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
                          hintText: S.of(context).hintCenter,
                          items: _centros,
                          numItems: 5,
                          isRed: _isCentroRed,
                        );
                      } else if (state is CentrosError) {
                        return SizedBox(
                          height: 100,
                          child: Center(child: Text(state.errorMessage)),
                        );
                      } else {  return const SizedBox(); }
                    },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Text(S.of(context).expirationDateAsterisk),
                  CustomDatePickerScroll(
                    onDateChanged: (DateTime newDate) {
                      _fechaCaducidad = newDate;
                      Fluttertoast.showToast(
                        msg:  Utils.getDifferenceBetweenDates(context, DateTime.now(), _fechaCaducidad),
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
                      Text(S.of(context).machineData, style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Text(S.of(context).denominationAsterisk),
                  MyTextField(
                      controller: _denominacionController,
                      hintText: S.of(context).hintDenomination,
                      isRed: _isNombreMaquinaRed,
                      focusNode: _campoDenominacionFocus,
                      onSubmited: () {
                        FocusScope.of(context).requestFocus(_campoFabricanteFocus);
                      },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Text(S.of(context).manufacturer),
                  MyTextField(
                      controller: _fabricanteController,
                      hintText: S.of(context).hintManufacturer,
                      focusNode: _campoFabricanteFocus,
                      onSubmited: () {
                        FocusScope.of(context).requestFocus(_campoNumeroSerieFocus);
                      },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Text(S.of(context).serialNumberAsterisk),
                  MyTextField(
                      controller: _numeroSerieController,
                      hintText: S.of(context).hintSerialNumber,
                      isRed: _isNumeroSerieRed,
                      focusNode: _campoNumeroSerieFocus,
                      onSubmited: () {
                        //FocusScope.of(context).requestFocus(_campoNumeroSerieFocus);
                      },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Text(S.of(context).manufacturedDateAsterisk),
                  CustomDatePicker(
                    onDateChanged: (DateTime? newDate) {
                      _fechaFabricacion = newDate;
                    },
                    selectedDateNotifier: _fechaFabricacionNotifier,
                    isRed: _isFechasRed,
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  Text(S.of(context).comissioningDateAsterisk),

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
                    visible: !_loadingImage && _imageList.isEmpty,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_a_photo, semanticLabel: S.of(context).semanticlabelAddImage),
                            onPressed: _checkImageLimit,
                            color: Colors.grey,
                          ),
                          Text(
                            S.of(context).addImage,
                            style: const TextStyle(
                              fontSize: Dimensions.smallTextSize,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Mostrar un cargando si _loadingImage es verdadero
                  Visibility(
                    visible: _loadingImage,
                    child: SizedBox(
                      height: 200,
                      child:  Center(
                        child: Text(S.of(context).uploadingImage)
                      ),
                    ),
                  ),

                  // Mostrar la lista de imágenes cuando no esté vacía y no se esté cargando
                  SizedBox(
                    height: _imageList.isNotEmpty && !_loadingImage ? 200 : 0, // Ajusta la altura según lo necesites
                    child: _imageList.isNotEmpty && !_loadingImage
                        ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _imageList.length + 1, // +1 para el botón más
                      itemBuilder: (BuildContext context, int index) {
                        if (index == _imageList.length) {
                          // Último ítem, mostrar el botón más
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
                                size: 48.0, semanticLabel: S.of(context).semanticlabelAddNewImage
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
                                  child: Utils.showImage(_imageList[index]),
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
                                    'assets/icons/ic_close.png',
                                    height: 25,
                                    width: 25,
                                    semanticLabel: S.of(context).semanticlabelDeleteImage,
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
                      setState(() {
                        _isNumeroSerieRed = false;
                        _isCentroRed = false;
                        _isFechasRed = false;
                        _isNombreMaquinaRed = false;
                      });
                      _showDialogCheck(context);
                    },
                    text: S.of(context).continuee,
                  ),
                  BlocListener<InsertarEvaluacionCubit, InsertarEvaluacionState>(
                      listener: (context, state) {
                        // Aquí puedes escuchar los cambios en el estado del bloc y reaccionar en consecuencia
                        if(state is InsertarEvaluacionLoading){
                          Navigator.of(context).pop(); //cerrar resumen
                          Utils.showLoadingDialog(context, text: S.of(context).savingEvaluation);
                        }else if(state is EvaluacionInsertada) {

                          // Crea una copia para evitar problemas con la mutabilidad
                          List<ImagenDataModel> imagenesCopy = List.from(state.imagenes);

                          Navigator.of(context).pop(); //cerrar cargando

                          _idEvaluacion = state.evaluacion.ideval;
                          _idMaquina = state.evaluacion.idmaquina;
                          _imageList.clear();
                          _imageList.addAll(imagenesCopy);


                          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckListPage(isModifying: _isModifiying, evaluacion: state.evaluacion, imagenes: _imageList,)),);

                        }else if(state is InsertarEvaluacionError){
                          Navigator.of(context).pop(); //cerrar cargando
                          Utils.showMyOkDialog(context, S.of(context).error, state.errorMessage, () {
                            Navigator.of(context).pop();
                          });
                        }
                      }, child: const SizedBox(),
                  ),
                  BlocListener<EliminarEvaluacionCubit, EliminarEvaluacionState>(
                      listener: (context, state) {
                        if(state is EliminarEvaluacionCompletada){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                        }else if (state is EliminarEvaluacionLoading) {
                          Utils.showLoadingDialog(context);
                        } else if (state is EliminarEvaluacionError) {
                          Navigator.of(context).pop();
                          Utils.showMyOkDialog(context, S.of(context).error, state.errorMessage, () {
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


