import 'dart:convert';

import 'package:dislacvta/models/articulostraspasos.dart';
import 'package:dislacvta/models/detalletraspasos.dart';
import 'package:dislacvta/models/historialtraspasos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TrapasosApi {
  TrapasosApi._internal();

  static TrapasosApi _instance = TrapasosApi._internal();
  static TrapasosApi get instance => _instance;

  Future<List<ArticuloTrapasos>> getArticulosTraspasos(String codigo) async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http
        .get(web.getString('WebApi') + '/api/SerachProduct?codigo=${codigo}');

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ArticuloTrapasos.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<int> addtraspaso(
      double cantidad, int articuloID, String claveArticulo) async {
    int traspasoID;
    SharedPreferences cliente = await SharedPreferences.getInstance();
    traspasoID = cliente.getInt('TraspasoID');

    final response = await http
        .post(cliente.getString('WebApi') + "/api/AgregarTraspaso", body: {
      "TraspasoID": traspasoID.toString(),
      "AlmacenOrigenID": cliente.getInt('AlmacenOrigenID').toString(),
      "AlmacenDestinoID": cliente.getInt('AlmacenDestinoID').toString(),
      "Unidades": cantidad.toString(),
      "ArticuloID": articuloID.toString(),
      "UsuarioID": cliente.getInt('VendedorID').toString(),
      "ClaveArticulo": claveArticulo
    });

    var datauser = json.decode(response.body);

    cliente.setInt('TraspasoID', datauser['TraspasoID']);

    return datauser['TraspasoID'];
  }

  Future<List<DetalleTraspasos>> getDetalleTraspasos() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    int traspasoID = web.getInt('TraspasoID');

    final response = await http.get(web.getString('WebApi') +
        '/api/DetalleTraspaso?TraspasoID=${traspasoID}');

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new DetalleTraspasos.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<bool> cerrarTraspaso() async {
    int traspasoID;
    SharedPreferences cliente = await SharedPreferences.getInstance();
    traspasoID = cliente.getInt('TraspasoID');

    final response = await http.get(cliente.getString('WebApi') +
        "/api/CerrarTraspaso?TraspasoID=${traspasoID}");

    var datauser = json.decode(response.body);
    cliente.setInt('TraspasoID', 0);

    return datauser['success'];
  }

  Future<List<HistorialTraspasos>> getHistorialTraspasos() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    int VendedorID = web.getInt('VendedorID');

    final response = await http.get(web.getString('WebApi') +
        '/api/HistorialTraspasos?UsuarioID=${VendedorID}');

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser
          .map((job) => new HistorialTraspasos.fromJson(job))
          .toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<HistorialTraspasos>> searchgetHistorialTraspasos(
      int traspasoID) async {
    SharedPreferences web = await SharedPreferences.getInstance();

    int VendedorID = web.getInt('VendedorID');

    final response = await http.get(web.getString('WebApi') +
        '/api/SearchHistorialTraspasos?UsuarioID=${VendedorID}&TraspasoID=${traspasoID}');

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser
          .map((job) => new HistorialTraspasos.fromJson(job))
          .toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<bool> deleteDetalle(int detalleTraspasoID) async {
    SharedPreferences web = await SharedPreferences.getInstance();

    try {
      final response = await http.get(web.getString('WebApi') +
          '/api/DeleteDetalle?TraspasoDetalleID=${detalleTraspasoID}');

      if (response.statusCode == 200) {
        var datauser = json.decode(response.body);
        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser['success'];
      }
    } catch (e) {
      print(e);
    }
  }
}
