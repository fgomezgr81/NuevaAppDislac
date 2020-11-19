import 'dart:convert';

import 'package:dislacvta/models/clientesvtas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ClientesvtaApi {
  ClientesvtaApi._internal();

  static ClientesvtaApi _instance = ClientesvtaApi._internal();
  static ClientesvtaApi get instance => _instance;

  //final _dio = Dio();

  Future<List<Clientesvtas>> getClientes() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http.get(web.getString('WebApi') +
        '/api/getClientes?VendedorID=' +
        web.getInt('VendedorID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new Clientesvtas.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Clientesvtas>> getClientesSearch(String nameCliente) async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();
    if (nameCliente.isNotEmpty) {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/getCliente?VendedorID=' +
          vendedorid.getInt('VendedorID').toString() +
          "&Nombre=" +
          nameCliente);

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);
        return datauser.map((job) => new Clientesvtas.fromJson(job)).toList();
      } else {
        throw Exception('Failed to load post');
      }
    } else {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/getClientes?VendedorID=' +
          vendedorid.getInt('VendedorID').toString());

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);
        return datauser.map((job) => new Clientesvtas.fromJson(job)).toList();
      } else {
        throw Exception('Failed to load post');
      }
    }
  }
}
