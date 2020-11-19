import 'dart:convert';

DetallePedidoVtas detallePedidoFromJson(String str) =>
    DetallePedidoVtas.fromJson(json.decode(str));

String detallePedidoToJson(DetallePedidoVtas data) =>
    json.encode(data.toJson());

class DetallePedidoVtas {
  DetallePedidoVtas({
    this.detalleArticulos,
    this.importe,
  });

  List<DetalleArticulo> detalleArticulos;
  double importe;

  factory DetallePedidoVtas.fromJson(Map<String, dynamic> json) =>
      DetallePedidoVtas(
        detalleArticulos: List<DetalleArticulo>.from(
            json["detalleArticulos"].map((x) => DetalleArticulo.fromJson(x))),
        importe: json["Importe"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "detalleArticulos":
            List<dynamic>.from(detalleArticulos.map((x) => x.toJson())),
        "Importe": importe,
      };
}

class DetalleArticulo {
  DetalleArticulo({
    this.detalleId,
    this.articuloId,
    this.articulo,
    this.unidades,
    this.precioUnitario,
    this.importe,
  });

  int detalleId;
  int articuloId;
  String articulo;
  double unidades;
  double precioUnitario;
  double importe;

  factory DetalleArticulo.fromJson(Map<String, dynamic> json) =>
      DetalleArticulo(
        detalleId: json["DetalleID"],
        articuloId: json["ArticuloID"],
        articulo: json["Articulo"],
        unidades: json["Unidades"],
        precioUnitario: json["PrecioUnitario"].toDouble(),
        importe: json["Importe"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "DetalleID": detalleId,
        "ArticuloID": articuloId,
        "Articulo": articulo,
        "Unidades": unidades,
        "PrecioUnitario": precioUnitario,
        "Importe": importe,
      };
}
