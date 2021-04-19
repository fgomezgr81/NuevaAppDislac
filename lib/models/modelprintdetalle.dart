class DetalleEncabezado {
  final int clienteid;
  final String cliente;
  final String fecha;
  final int formaPagoID;
  final double importe;
  final double iva;
  final String folio;
  final List<Detalle> detallepedido;
  final List<Detalle> detalledevoluciones;

  DetalleEncabezado(
      {this.cliente,
      this.formaPagoID,
      this.clienteid,
      this.importe,
      this.fecha,
      this.iva,
      this.folio,
      this.detallepedido,
      this.detalledevoluciones});

  factory DetalleEncabezado.fromJson(Map<String, dynamic> json) {
    var list = json['detalleArticulos'] as List;
    var listdev = json['devoluciones'] as List;
    return DetalleEncabezado(
      cliente: json['Cliente'],
      clienteid: json['ClienteID'],
      fecha: json['Fecha'],
      iva: json['IVA'],
      formaPagoID: json['FormaPagoID'],
      importe: json['Importe'],
      folio: json['Folio'],
      detallepedido: list.map((i) => Detalle.fromJson(i)).toList(),
      detalledevoluciones: listdev.map((i) => Detalle.fromJson(i)).toList(),
    );
  }
}

class Detalle {
  final int articuloid;
  final String articulo;
  final double unidades;
  final double precio;
  final double importe;

  Detalle(
      {this.articuloid,
      this.articulo,
      this.importe,
      this.precio,
      this.unidades});

  factory Detalle.fromJson(Map<dynamic, dynamic> json) {
    return Detalle(
      articuloid: json['ArticuloId'],
      articulo: json['Articulo'],
      unidades: json['Unidades'],
      precio: json['PrecioUnitario'],
      importe: json['Importe'],
    );
  }
}
