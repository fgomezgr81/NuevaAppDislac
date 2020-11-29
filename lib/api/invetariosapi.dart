import 'dart:convert';

import 'package:dislacvta/models/detailinventarios.dart';
import 'package:dislacvta/models/detalleinventario.dart';
import 'package:dislacvta/models/modelinventarios.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InvetariosApi {
  InvetariosApi._internal();

  static InvetariosApi _instance = InvetariosApi._internal();
  static InvetariosApi get instance => _instance;

  Future<List<ModelInventariosDetail>> getInventariosDetalle() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http.get(web.getString('WebApi') +
        '/api/DetalleInventario?InventarioID=' +
        web.getInt('InventarioID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser
          .map((job) => new ModelInventariosDetail.fromJson(job))
          .toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<ModelInventarios>> getInventarios() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response =
        await http.get(web.getString('WebApi') + '/api/GetInventarios');

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ModelInventarios.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<int> addInventario(
      int articuloID, double unidades, String claveArticulo) async {
    SharedPreferences cliente = await SharedPreferences.getInstance();
    int _inventarioID = cliente.getInt('InventarioID');

    final response = await http
        .post(cliente.getString('WebApi') + "/api/NewInvetory", body: {
      "InventarioID": _inventarioID.toString(),
      "AlmacenID": cliente.getInt('AlmacenID').toString(),
      "Cantidad": unidades.toString(),
      "ArticuloID": articuloID.toString(),
      "VendedorID": cliente.getInt('VendedorID').toString()
    });

    print(response.body);
    var datauser = json.decode(response.body);

    cliente.setInt('InventarioID', datauser['InventarioID']);

    return datauser['InventarioID'];
  }

  Future<bool> cerrarInventario() async {
    int inventarioID;
    SharedPreferences cliente = await SharedPreferences.getInstance();
    inventarioID = cliente.getInt('InventarioID');

    final response = await http.get(cliente.getString('WebApi') +
        "/api/CerrarInvetario?InventarioID=${inventarioID}");

    var datauser = json.decode(response.body);
    cliente.setInt('InventarioID', 0);

    return datauser['success'];
  }

  Future<List<ModelDetalleInventario>> getDetalleInventario() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    int inventarioID = web.getInt('InventarioID');

    final response = await http.get(web.getString('WebApi') +
        '/api/DetalleInventario?InventarioID=${inventarioID}');

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser
          .map((job) => new ModelDetalleInventario.fromJson(job))
          .toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }
}
