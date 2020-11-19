import 'dart:convert';

List<ModelAlmacenes> modelAlmacenesFromJson(String str) =>
    List<ModelAlmacenes>.from(
        json.decode(str).map((x) => ModelAlmacenes.fromJson(x)));

String modelAlmacenesToJson(List<ModelAlmacenes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAlmacenes {
  ModelAlmacenes({
    this.almacenId,
    this.almacen,
  });

  int almacenId;
  String almacen;

  factory ModelAlmacenes.fromJson(Map<String, dynamic> json) => ModelAlmacenes(
        almacenId: json["AlmacenID"],
        almacen: json["Almacen"],
      );

  Map<String, dynamic> toJson() => {
        "AlmacenID": almacenId,
        "Almacen": almacen,
      };
}
