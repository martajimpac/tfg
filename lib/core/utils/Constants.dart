int selectedIndexHome = 0;

const String filtroCentro = "Centro";
const String filtroFechaRealizacion = "Fecha realización";
const String filtroFechaCaducidad = "Fecha caducidad";
const String filtroDenominacion = "Nombre máquina";

//Posibles valores: desarrollo, producción
enum EntornoVersion { desarrollo, produccion }

const EntornoVersion entornoVersion = EntornoVersion.desarrollo;

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