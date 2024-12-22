class InspectorDataModel {
  int? id;
  String usuario;
  String? contrasena;

  InspectorDataModel({
    this.id,
    required this.usuario,
    this.contrasena,
  });

  factory InspectorDataModel.fromMap(Map<String, dynamic> map) =>
      InspectorDataModel(
        id: map["id"],
        usuario: map["usuario"],
        contrasena: map["contrasena"],
      );

  factory InspectorDataModel.fromJson(Map<String, dynamic> json) =>
      InspectorDataModel(
        id: json["id"],
        usuario: json["usuario"],
        contrasena: json["contrasena"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "contrasena": contrasena,
      };
}
