/// nombre : "Afganistán"
/// name : "Afghanistan"
/// nom : "Afghanistan"
/// iso2 : "AF"
/// iso3 : "AFG"
/// phone_code : "93"

class PaisDataModel {
  String nombre;
  String name;
  String nom;
  String iso2;
  String iso3;
  String? phoneCode;

  PaisDataModel(
      {required this.nombre,
      required this.name,
      required this.nom,
      required this.iso2,
      required this.iso3,
      this.phoneCode});
  factory PaisDataModel.fromJson(json) {
    return PaisDataModel(
      nombre: json['nombre'],
      name: json['name'],
      nom: json['nom'],
      iso2: json['iso2'],
      iso3: json['iso3'],
      phoneCode: json['phone_code'] ?? json['phoneCode'],
    );
  }

  factory PaisDataModel.fromMap(Map<String, dynamic> map) {
    return PaisDataModel(
      nombre: map['nombre'],
      name: map['name'],
      nom: map['nom'],
      iso2: map['iso2'],
      iso3: map['iso3'],
      phoneCode: map['phone_code'] ?? map['phoneCode'],
    );
  }
}
