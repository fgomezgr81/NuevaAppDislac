class ModelPedido {
  final int idDocumento;
  final String nombre;
  final double importe;
  final int pagoid;
  final int formapagoid;
  final DateTime fecha;
  final String formaCobro;

  ModelPedido(
      {this.idDocumento,
      this.nombre,
      this.importe,
      this.pagoid,
      this.formapagoid,
      this.fecha,
      this.formaCobro});

  factory ModelPedido.fromJson(Map<String, dynamic> json) {
    return ModelPedido(
        idDocumento: json['DocumentoID'],
        nombre: json['Nombre'],
        pagoid: json['PagoID'],
        importe: json['Importe'],
        formapagoid: json['FormaPagoID'],
        fecha: DateTime.parse(json['Fecha']),
        formaCobro: json['FormaCobro']);
  }
}
