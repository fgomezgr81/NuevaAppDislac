import 'dart:convert';

import 'package:dislacvta/models/modelprintdetalle.dart';
import 'package:dislacvta/models/pedidosvtas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PedidosvtaApi {
  PedidosvtaApi._internal();

  static PedidosvtaApi _instance = PedidosvtaApi._internal();
  static PedidosvtaApi get instance => _instance;

  //obtenemos los pedidos del vendedor
  Future<List<ModelPedido>> getPedidos() async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();

    final response = await http.get(vendedorid.getString('WebApi') +
        '/api/GetPedidosVendedor?VendedorID=' +
        vendedorid.getInt('VendedorID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);

      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

//obtenemos los pedidos del vendedorModelPedido
  Future<List<ModelPedido>> searchPedidos(String cliente) async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();

    if (cliente.isNotEmpty) {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/GetPedidosClientes?VendedorID=' +
          vendedorid.getInt('VendedorID').toString() +
          "&Cliente=" +
          cliente);

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);

        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
      } else {
        // Si la llamada no fue exitosa, lanza un error.
        throw Exception('Failed to load post');
      }
    } else {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/GetPedidosVendedor?VendedorID=' +
          vendedorid.getInt('VendedorID').toString() +
          "&Cliente=" +
          cliente);

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);

        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
      } else {
        // Si la llamada no fue exitosa, lanza un error.
        throw Exception('Failed to load post');
      }
    }
  }

  Future<void> pagarPedido(
      int formapago, int pedidoID, String banco, String referencia) async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http
        .post(web.getString('WebApi') + "/api/PagaraDocumentos", body: {
      "DocumentoID": pedidoID.toString(),
      "FormaPagoID": formapago.toString(),
      "Estatus": 'PA',
      "Banco": banco,
      "Referencia": referencia
    });
    return response.statusCode;
  }

  Future<List<ModelPedido>> getPedidosCredito() async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();

    final response = await http.get(vendedorid.getString('WebApi') +
        '/api/GetPedidosVendedorCredito?VendedorID=' +
        vendedorid.getInt('VendedorID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);

      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

//obtenemos los pedidos del vendedor
  Future<List<ModelPedido>> searchPedidosCredito(String cliente) async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();

    if (cliente.isNotEmpty) {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/GetPedidosClientesCredito?VendedorID=' +
          vendedorid.getInt('VendedorID').toString() +
          "&Cliente=" +
          cliente);

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);

        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
      } else {
        // Si la llamada no fue exitosa, lanza un error.
        throw Exception('Failed to load post');
      }
    } else {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/GetPedidosVendedorCredito?VendedorID=' +
          vendedorid.getInt('VendedorID').toString());

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);

        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
      } else {
        // Si la llamada no fue exitosa, lanza un error.
        throw Exception('Failed to load post');
      }
    }
  }

  Future<List<ModelPedido>> getPedidosHistorico() async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();

    final response = await http.get(vendedorid.getString('WebApi') +
        '/api/GetPedidosHistoricoVendedor?VendedorID=' +
        vendedorid.getInt('VendedorID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);

      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

//obtenemos los pedidos del vendedor
  Future<List<ModelPedido>> searchPedidosHistorico(String cliente) async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();

    if (cliente.isNotEmpty) {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/GetPedidosClientes?VendedorID=' +
          vendedorid.getInt('VendedorID').toString() +
          "&Cliente=" +
          cliente);

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);

        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
      } else {
        // Si la llamada no fue exitosa, lanza un error.
        throw Exception('Failed to load post');
      }
    } else {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/GetPedidosHistoricoVendedor?VendedorID=' +
          vendedorid.getInt('VendedorID').toString());

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);

        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
      } else {
        // Si la llamada no fue exitosa, lanza un error.
        throw Exception('Failed to load post');
      }
    }
  }

  Future<bool> devolucion(int idDetalle, double devolucion) async {
    SharedPreferences cliente = await SharedPreferences.getInstance();

    final response = await http
        .post(cliente.getString('WebApi') + "/api/AddDevoluciones", body: {
      "DetalleID": idDetalle.toString(),
      "Devolucion": devolucion.toString(),
    });

    var datauser = json.decode(response.body);
    return datauser['success'];
  }

  Future<DetalleEncabezado> getDetallePedido(int pedidoID) async {
    SharedPreferences config = await SharedPreferences.getInstance();

    final response = await http.get(config.getString('WebApi') +
        "/api/GetPedidoDetalle?DocumentoID=" +
        pedidoID.toString());

    if (response.statusCode == 200) {
      return DetalleEncabezado.fromJson(json.decode(response.body));
    }
    return null;
  }

  Future<List<ModelPedido>> getPagoPedidos(int clienteID) async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();

    final response = await http.get(vendedorid.getString('WebApi') +
        '/api/GetPedidosPorCliente?ClienteID=' +
        clienteID.toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);

      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

//obtenemos los pedidos de un cliente
  Future<List<ModelPedido>> searchgetPagoPedidos(String cliente) async {
    SharedPreferences vendedorid = await SharedPreferences.getInstance();

    if (cliente.isNotEmpty) {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/GetPedidosClientes?VendedorID=' +
          vendedorid.getInt('VendedorID').toString() +
          "&Cliente=" +
          cliente);

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);

        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
      } else {
        // Si la llamada no fue exitosa, lanza un error.
        throw Exception('Failed to load post');
      }
    } else {
      final response = await http.get(vendedorid.getString('WebApi') +
          '/api/GetPedidosVendedor?VendedorID=' +
          vendedorid.getInt('VendedorID').toString() +
          "&Cliente=" +
          cliente);

      if (response.statusCode == 200) {
        List datauser = json.decode(response.body);

        // Si la llamada al servidor fue exitosa, analiza el JSON
        return datauser.map((job) => new ModelPedido.fromJson(job)).toList();
      } else {
        // Si la llamada no fue exitosa, lanza un error.
        throw Exception('Failed to load post');
      }
    }
  }
}
