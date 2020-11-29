import 'dart:convert';

List<ModelOrdenCompra> modelOrdenCompraFromJson(String str) =>
    List<ModelOrdenCompra>.from(
        json.decode(str).map((x) => ModelOrdenCompra.fromJson(x)));

String modelOrdenCompraToJson(List<ModelOrdenCompra> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelOrdenCompra {
  ModelOrdenCompra(
      {this.folioOc, this.proveedor, this.fechaOc, this.ordenID, this.estatus});

  String folioOc;
  String proveedor;
  DateTime fechaOc;
  int ordenID;
  String estatus;

  factory ModelOrdenCompra.fromJson(Map<String, dynamic> json) =>
      ModelOrdenCompra(
        folioOc: json["FolioOC"],
        proveedor: json["Proveedor"],
        fechaOc: DateTime.parse(json["FechaOC"]),
        ordenID: json["OrdenCompraID"],
        estatus: json["Estatus"],
      );

  Map<String, dynamic> toJson() => {
        "FolioOC": folioOc,
        "Proveedor": proveedor,
        "FechaOC": fechaOc.toIso8601String(),
        "OrdenCompraID": ordenID,
        "Estatus": estatus
      };
}
