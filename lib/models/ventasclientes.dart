class VentaClientes {
  final String cliente;
  final double importe;

  VentaClientes({this.cliente, this.importe});

  factory VentaClientes.fromJson(Map<String, dynamic> json) {
    return VentaClientes(
      cliente: json['Concepto'],
      importe: json['Total'],
    );
  }
}
