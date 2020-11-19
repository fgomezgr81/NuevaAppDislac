import 'dart:convert';

List<ProductoCliente> productoClienteFromJson(String str) =>
    List<ProductoCliente>.from(
        json.decode(str).map((x) => ProductoCliente.fromJson(x)));

String productoClienteToJson(List<ProductoCliente> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductoCliente {
  ProductoCliente({
    this.articuloId,
    this.articulo,
    this.existencia,
    this.precio,
  });

  int articuloId;
  String articulo;
  double existencia;
  double precio;

  factory ProductoCliente.fromJson(Map<String, dynamic> json) =>
      ProductoCliente(
        articuloId: json["ArticuloID"],
        articulo: json["Articulo"],
        existencia: json["Existencia"].toDouble(),
        precio: json["Precio"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "ArticuloID": articuloId,
        "Articulo": articulo,
        "Existencia": existencia,
        "Precio": precio,
      };
}
