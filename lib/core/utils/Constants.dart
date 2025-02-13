int selectedIndexHome = 0;

const String filtroCentro = "Centro";
const String filtroFechaRealizacion = "Fecha realización";
const String filtroFechaCaducidad = "Fecha caducidad";

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


const bucketName = "images";

enum Categorias {
  catMaqCarga1(6),
  catMaqCarga2(7),
  catMaqMovil1(8),
  catMaqMovil2(9);

  final int value;
  const Categorias(this.value);
}