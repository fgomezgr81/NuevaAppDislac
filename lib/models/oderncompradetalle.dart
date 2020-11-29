import 'dart:convert';

List<ModelOrdenCompraDetalle> modelOrdenCompraDetalleFromJson(String str) =>
    List<ModelOrdenCompraDetalle>.from(
        json.decode(str).map((x) => ModelOrdenCompraDetalle.fromJson(x)));

String modelOrdenCompraDetalleToJson(List<ModelOrdenCompraDetalle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelOrdenCompraDetalle {
  ModelOrdenCompraDetalle({
    this.articuloId,
    this.detalleOrdenId,
    this.nombre,
    this.claveArticulo,
    this.unidadesSolicitadas,
  });

  int articuloId;
  int detalleOrdenId;
  String nombre;
  String claveArticulo;
  double unidadesSolicitadas;

  factory ModelOrdenCompraDetalle.fromJson(Map<String, dynamic> json) =>
      ModelOrdenCompraDetalle(
        articuloId: json["ArticuloID"],
        detalleOrdenId: json["DetalleOrdenID"],
        nombre: json["Nombre"],
        claveArticulo: json["ClaveArticulo"],
        unidadesSolicitadas: json["UnidadesSolicitadas"],
      );

  Map<String, dynamic> toJson() => {
        "ArticuloID": articuloId,
        "DetalleOrdenID": detalleOrdenId,
        "Nombre": nombre,
        "ClaveArticulo": claveArticulo,
        "UnidadesSolicitadas": unidadesSolicitadas,
      };
}
