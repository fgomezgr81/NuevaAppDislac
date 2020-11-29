import 'dart:convert';

ModelInventarios detallePedidoFromJson(String str) =>
    ModelInventarios.fromJson(json.decode(str));

String detallePedidoToJson(ModelInventarios data) => json.encode(data.toJson());

class ModelInventarios {
  ModelInventarios({
    this.inventarioID,
    this.almacen,
    this.fecha,
    this.estatus,
  });

  int inventarioID;
  String almacen;
  String fecha;
  String estatus;

  factory ModelInventarios.fromJson(Map<String, dynamic> json) =>
      ModelInventarios(
        inventarioID: json["InventarioID"],
        almacen: json["Almacen"],
        fecha: json["Fecha"],
        estatus: json["Estatus"],
      );

  Map<String, dynamic> toJson() => {
        "InventarioID": inventarioID,
        "Almacen": almacen,
        "Fecha": fecha,
        "Estatus": estatus,
      };
}
