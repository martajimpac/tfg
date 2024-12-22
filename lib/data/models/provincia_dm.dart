class ProvinciaDataModel {
  final int id;
  final int?
      idCA; //id de la comunidad autónoma a la que pertenece. Si es nulo es Ceuta o Melilla
  final String provincia;

  //Constructor (tanto id como provincia son obligatorios
  ProvinciaDataModel(
      {required this.id, required this.provincia, required this.idCA});

  factory ProvinciaDataModel.fromMap(Map<String, dynamic> map) {
    final id = map["id"];

    ///Si no existe el idCA, se pone a 0 (para Ceuta y Melilla)
    final idCA = map["idca"] ?? 0;
    final provincia = map["denominacion"];
    return ProvinciaDataModel(id: id, provincia: provincia, idCA: idCA);
  }

  factory ProvinciaDataModel.fromJSON(json) {
    final int id = int.parse(json["id"]);
    final provincia = json["provincia"];
    final int idCA = int.parse(json["idCA"]);
    return ProvinciaDataModel(id: id, provincia: provincia, idCA: idCA);
  }

  static List<ProvinciaDataModel> listaProvinciasFromJson(
      List<dynamic> parsedJson) {
    List<ProvinciaDataModel> listaProvincias = [];
    listaProvincias =
        parsedJson.map((e) => ProvinciaDataModel.fromJSON(e)).toList();
    return listaProvincias;
  }
}
