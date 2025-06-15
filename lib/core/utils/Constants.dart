import 'package:flutter/cupertino.dart';

int selectedIndexHome = 0;


const String filtroCentro = "Centro";
const String filtroFechaRealizacion = "Fecha realización";
const String filtroFechaCaducidad = "Fecha caducidad";
const String filtroDenominacion = "Nombre máquina";



const DateFormatString = 'dd/MM/yyyy';

const QRPage = "https://martajimpac.github.io/tfg/redirect?id=";
const emailConfirmationPage = "https://martajimpac.github.io/tfg";

///Acciones que se pueden realizar con los pdf y execl de los checkist
enum AccionesPdfChecklist { guardar, compartir }
//Listado de tipos de ficheros que podemos crear
enum TiposFicheros { word, excel, pdf }

const idMaqCarga1 = 6;
const idMaqCarga2 = 7;
const idMaqMovil1 = 8;
const idMaqMovil2 = 9;

const bucketName = "images";

//Códigos de error
const errorEmpty = "ERROR_EMPTY";
const defaultError = "ERROR_DEFAULT";

//Keys to find components in integration test
//home
const Key addButtonKey = Key('add_button');
const Key buttonProfileKey = Key('button_profile_key');

//nueva evaluacion page
const Key fechaFabricacionKey = Key('fabrication_date_picker_key');
const Key fechaServicioKey = Key('service_date_picker_key');
const Key arrowCentersKey = Key('arrow_centers_key');
const Key listViewNewEvaluationKey = Key('listview_new_evaluation_key');
const Key listViewCentersKey = Key('listview_centers_key');
const Key buttonFinishEvaluationKey = Key('button_finish_evaluation_key');
const Key listViewMachinesKey = Key('listview_machines_key');

//checklist page
const Key listViewCategoriesKey = Key('listview_categories_key');
const Key buttonFinishChecklistKey = Key('button_finish_checklist_key');

//evaluations page
const Key listViewEvaluationsKey = Key('listview_evaluations_key');
const Key buttonDeleteEvaluationKey = Key('button_delete_evaluation_key');
const Key buttonFiltersKey = Key('button_filters_key');

//Filters page
const Key buttonApplyFiltersKey = Key('button_apply_filters_key');
const Key filtroFechaRealizacionKey = Key('filtro_fecha_realizacion_key');
const Key filtroFechaCaducidadKey = Key('filtro_fecha_caducidad_key');

//Profile page
const Key buttonChangePasswordKey = Key('button_change_password_key');
const Key buttonEditProfileKey = Key('button_edit_profile_key');
const Key buttonLogoutKey = Key('button_logout_key');

//Edit profile page
const Key buttonSaveProfileKey = Key('button_save_profile_key');

//Change password page
const Key buttonChangePasswordPageKey = Key('button_change_password_page_key');
const Key fieldCurrentPasswordKey = Key('field_current_password_key');
const Key fieldNewPasswordKey = Key('field_new_password_key');
const Key fieldRepeatPasswordKey = Key('field_repeat_password_key');

//dialog
const Key okButtonKey = Key('ok_button_key');
const Key primaryButtonKey = Key('primary_button_key');
