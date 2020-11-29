import 'dart:convert';

ModelInventariosDetail detallePedidoFromJson(String str) =>
    ModelInventariosDetail.fromJson(json.decode(str));

String detallePedidoToJson(ModelInventariosDetail data) =>
    json.encode(data.toJson());

class ModelInventariosDetail {
  ModelInventariosDetail({
    this.detalleId,
    this.articuloId,
    this.articulo,
    this.unidades,
  });

  int detalleId;
  int articuloId;
  String articulo;
  double unidades;

  factory ModelInventariosDetail.fromJson(Map<String, dynamic> json) =>
      ModelInventariosDetail(
        detalleId: json["DetalleID"],
        articuloId: json["ArticuloID"],
        articulo: json["Articulo"],
        unidades: json["Unidades"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "DetalleID": detalleId,
        "ArticuloID": articuloId,
        "Articulo": articulo,
        "Unidades": unidades,
      };
}
