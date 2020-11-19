import 'dart:convert';

List<HistorialTraspasos> historialTraspasosFromJson(String str) =>
    List<HistorialTraspasos>.from(
        json.decode(str).map((x) => HistorialTraspasos.fromJson(x)));

String historialTraspasosToJson(List<HistorialTraspasos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistorialTraspasos {
  HistorialTraspasos({
    this.traspasoId,
    this.almacenOrigen,
    this.almacenDestino,
    this.usuario,
    this.estatus,
    this.almacenOrigenId,
    this.almacenDestinoId,
    this.claveArticulo,
  });

  int traspasoId;
  String almacenOrigen;
  String almacenDestino;
  dynamic usuario;
  String estatus;
  int almacenOrigenId;
  int almacenDestinoId;
  String claveArticulo;

  factory HistorialTraspasos.fromJson(Map<String, dynamic> json) =>
      HistorialTraspasos(
        traspasoId: json["TraspasoID"],
        almacenOrigen: json["AlmacenOrigen"],
        almacenDestino: json["AlmacenDestino"],
        usuario: json["Usuario"],
        estatus: json["Estatus"],
        almacenOrigenId: json["AlmacenOrigenID"],
        almacenDestinoId: json["AlmacenDestinoID"],
        claveArticulo: json["ClaveArticulo"],
      );

  Map<String, dynamic> toJson() => {
        "TraspasoID": traspasoId,
        "AlmacenOrigen": almacenOrigen,
        "AlmacenDestino": almacenDestino,
        "Usuario": usuario,
        "Estatus": estatus,
        "AlmacenOrigenID": almacenOrigenId,
        "AlmacenDestinoID": almacenDestinoId,
        "ClaveArticulo": claveArticulo
      };
}
