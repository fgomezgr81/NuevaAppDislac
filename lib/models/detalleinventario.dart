// To parse this JSON data, do
//
//     final modelDetalleInventario = modelDetalleInventarioFromJson(jsonString);

import 'dart:convert';

List<ModelDetalleInventario> modelDetalleInventarioFromJson(String str) =>
    List<ModelDetalleInventario>.from(
        json.decode(str).map((x) => ModelDetalleInventario.fromJson(x)));

String modelDetalleInventarioToJson(List<ModelDetalleInventario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelDetalleInventario {
  ModelDetalleInventario({
    this.detalleId,
    this.articulo,
    this.codigo,
    this.unidades,
  });

  int detalleId;
  String articulo;
  String codigo;
  double unidades;

  factory ModelDetalleInventario.fromJson(Map<String, dynamic> json) =>
      ModelDetalleInventario(
        detalleId: json["DetalleID"],
        articulo: json["Articulo"],
        codigo: json["Codigo"],
        unidades: json["Unidades"],
      );

  Map<String, dynamic> toJson() => {
        "DetalleID": detalleId,
        "Articulo": articulo,
        "Codigo": codigo,
        "Unidades": unidades,
      };
}
