import 'dart:convert';

List<DetalleTraspasos> detalleTraspasosFromJson(String str) =>
    List<DetalleTraspasos>.from(
        json.decode(str).map((x) => DetalleTraspasos.fromJson(x)));

String detalleTraspasosToJson(List<DetalleTraspasos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetalleTraspasos {
  DetalleTraspasos(
      {this.articuloId,
      this.descripcion,
      this.unidades,
      this.claveArticulo,
      this.trapasoDetalleID});

  int articuloId;
  String descripcion;
  double unidades;
  String claveArticulo;
  int trapasoDetalleID;

  factory DetalleTraspasos.fromJson(Map<String, dynamic> json) =>
      DetalleTraspasos(
        articuloId: json["ArticuloID"],
        descripcion: json["Descripcion"],
        unidades: json["Unidades"],
        claveArticulo: json["ClaveArticulo"],
        trapasoDetalleID: json["TraspasoDetalleID"],
      );

  Map<String, dynamic> toJson() => {
        "ArticuloID": articuloId,
        "Descripcion": descripcion,
        "Unidades": unidades,
        "ClaveArticulo": claveArticulo,
        "TraspasoDetalleID": trapasoDetalleID
      };
}
