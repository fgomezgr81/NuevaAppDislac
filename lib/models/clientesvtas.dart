import 'dart:convert';

List<Clientesvtas> clientesvtasFromJson(String str) => List<Clientesvtas>.from(
    json.decode(str).map((x) => Clientesvtas.fromJson(x)));

String clientesvtasToJson(List<Clientesvtas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Clientesvtas {
  Clientesvtas({
    this.clienteId,
    this.nombre,
    this.credito,
    this.estatus,
  });

  int clienteId;
  String nombre;
  int credito;
  String estatus;

  factory Clientesvtas.fromJson(Map<String, dynamic> json) => Clientesvtas(
        clienteId: json["ClienteID"],
        nombre: json["Nombre"],
        credito: json["Credito"],
        estatus: json["Estatus"],
      );

  Map<String, dynamic> toJson() => {
        "ClienteID": clienteId,
        "Nombre": nombre,
        "Credito": credito,
        "Estatus": estatus,
      };
}
