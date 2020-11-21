import 'dart:convert';

import 'package:dislacvta/models/corte.dart';
import 'package:dislacvta/models/ventasclientes.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CorteApi {
  CorteApi._internal();

  static CorteApi _instance = CorteApi._internal();
  static CorteApi get instance => _instance;

  Future<List<CorteDia>> fetchgetCortePost() async {
    SharedPreferences cliente = await SharedPreferences.getInstance();

    final response = await http.get(cliente.getString('WebApi') +
        '/api/GetCorteDia?VendedorID=' +
        cliente.getInt('VendedorID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);

      return datauser.map((job) => new CorteDia.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<CorteDia>> ventaDia() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http.get(web.getString('WebApi') +
        "/api/GetVentaDia?VendedorID=" +
        web.getInt('VendedorID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      return datauser.map((job) => new CorteDia.fromJson(job)).toList();
    }
  }

  Future<List<VentaClientes>> ventaDiaCliente() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final responsevta = await http.get(web.getString('WebApi') +
        "/api/GetVentaDiaClientes?VendedorID=" +
        web.getInt('VendedorID').toString());

    if (responsevta.statusCode == 200) {
      List datauservta = json.decode(responsevta.body);
      return datauservta.map((job) => new VentaClientes.fromJson(job)).toList();
    }
  }
}
