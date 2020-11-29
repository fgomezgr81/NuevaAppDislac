import 'dart:convert';

import 'package:dislacvta/models/oderncompradetalle.dart';
import 'package:dislacvta/models/ordenescompra.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrdenesCompraApi {
  OrdenesCompraApi._internal();

  static OrdenesCompraApi _instance = OrdenesCompraApi._internal();
  static OrdenesCompraApi get instance => _instance;

  Future<List<ModelOrdenCompra>> getOrdnesCompra() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response =
        await http.get(web.getString('WebApi') + '/api/OrdenCompra');

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ModelOrdenCompra.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<ModelOrdenCompraDetalle>> getOrdnesCompraDetalle() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http.get(web.getString('WebApi') +
        '/api/OrdenCompraDetalle?OrdenCompraID=' +
        web.getInt('OrdenCompraID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser
          .map((job) => new ModelOrdenCompraDetalle.fromJson(job))
          .toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<ModelOrdenCompraDetalle>> searchOrdnesCompraDetalle(
      String clave) async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http.get(web.getString('WebApi') +
        '/api/SearchOrdenCompraDetalle?OrdenCompraID=' +
        web.getInt('OrdenCompraID').toString() +
        "&clave=" +
        clave);

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      print(datauser);
      return datauser
          .map((job) => new ModelOrdenCompraDetalle.fromJson(job))
          .toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<bool> recepcion(int detalleID, double cantidad) async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http
        .post(web.getString('WebApi') + '/api/RegistrarRecepcion', body: {
      "DetalleID": detalleID.toString(),
      "Cantidad": cantidad.toString(),
      "RecepcionID": web.getInt('OrdenCompraID').toString()
    });

    if (response.statusCode == 200) {
      var datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser["sucess"];
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      return false;
    }
  }

  Future<bool> cerrarrRecepcion() async {
    int recepcionID;
    SharedPreferences cliente = await SharedPreferences.getInstance();
    recepcionID = cliente.getInt('OrdenCompraID');

    final response = await http.get(cliente.getString('WebApi') +
        "/api/CerrarRecepcion?RecepcionID=${recepcionID}");

    var datauser = json.decode(response.body);
    cliente.setInt('OrdenCompraID', 0);

    return datauser['success'];
  }
}
