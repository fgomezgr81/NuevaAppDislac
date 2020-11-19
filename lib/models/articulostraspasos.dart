import 'dart:convert';

List<ArticuloTrapasos> articuloTrapasosFromJson(String str) =>
    List<ArticuloTrapasos>.from(
        json.decode(str).map((x) => ArticuloTrapasos.fromJson(x)));

String articuloTrapasosToJson(List<ArticuloTrapasos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArticuloTrapasos {
  ArticuloTrapasos(
      {this.articuloId, this.articulo, this.unidadVenta, this.claveArticulo});

  int articuloId;
  String articulo;
  String unidadVenta;
  String claveArticulo;

  factory ArticuloTrapasos.fromJson(Map<String, dynamic> json) =>
      ArticuloTrapasos(
        articuloId: json["ArticuloID"],
        articulo: json["Articulo"],
        unidadVenta: json["UnidadVenta"],
        claveArticulo: json["ClaveArticulo"],
      );

  Map<String, dynamic> toJson() => {
        "ArticuloID": articuloId,
        "Articulo": articulo,
        "UnidadVenta": unidadVenta,
        "ClaveArticulo": claveArticulo
      };
}
