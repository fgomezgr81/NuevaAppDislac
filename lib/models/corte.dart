class CorteDia {
  final String concepto;
  final double total;

  CorteDia({this.concepto, this.total});

  factory CorteDia.fromJson(Map<String, dynamic> json) {
    return CorteDia(
      concepto: json['Concepto'],
      total: json['Total'],
    );
  }
}
