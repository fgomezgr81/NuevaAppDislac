import 'dart:convert';

import 'package:dislacvta/models/detallepedidovtas.dart';
import 'package:dislacvta/models/productocliente.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductosClienteApi {
  ProductosClienteApi._internal();

  static ProductosClienteApi _instance = ProductosClienteApi._internal();
  static ProductosClienteApi get instance => _instance;

  Future<List<ProductoCliente>> getProductoCliente() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response = await http.get(web.getString('WebApi') +
        '/api/ArticulosCliente?ClienteID=' +
        web.getInt('ClienteID').toString());

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ProductoCliente.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  Future<int> addproduct(
      double cantidad, int articuloID, double precio, double cambio) async {
    int pedidoID;
    SharedPreferences cliente = await SharedPreferences.getInstance();
    pedidoID = cliente.getInt('PedidoID');

    final response = await http
        .post(cliente.getString('WebApi') + "/api/AgregarPedido", body: {
      "ClienteID": cliente.getInt('ClienteID').toString(),
      "VendedorID": cliente.getInt('VendedorID').toString(),
      "DocumentoID": pedidoID.toString(),
      "Cantidad": cantidad.toString(),
      "ArticuloID": articuloID.toString(),
      "Precio": precio.toString(),
      "CantidadCambio": cambio.toString(),
    });

    var datauser = json.decode(response.body);

    cliente.setInt('PedidoID', datauser['DocumentoID']);

    return datauser['DocumentoID'];
  }

  Future<bool> cerrarPedido(
      int formapago, String tipo, String referencia) async {
    try {
      SharedPreferences device = await SharedPreferences.getInstance();
      int pedidoID = device.getInt('PedidoID');

      final response = await http
          .post(device.getString('WebApi') + "/api/CerrarPedido", body: {
        "DocumentoID": pedidoID.toString(),
        "FormaPagoID": formapago.toString(),
        "Banco": tipo,
        "Referencia": referencia,
        "Device": device.getString("deviceId"),
      });
      var datauser = json.decode(response.body);
      if (datauser['success'] == true) {
        device.setInt('ClienteID', 0);
        device.setInt('PedidoID', 0);
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      print(e);
      print(s);
      return false;
    }
  }

  Future<DetallePedidoVtas> getDetallePedido() async {
    SharedPreferences pedidoID = await SharedPreferences.getInstance();

    try {
      final response = await http.get(pedidoID.getString('WebApi') +
          '/api/GetDetallePedido?DocumentoID=' +
          pedidoID.getInt("PedidoID").toString());

      var datas = json.decode(response.body);

      if (response.statusCode == 200) {
        List datauser = datas['detalleArticulos'];
        DetallePedidoVtas detail = new DetallePedidoVtas();

        detail.detalleArticulos =
            datauser.map((job) => new DetalleArticulo.fromJson(job)).toList();
        detail.importe = datas['Importe'];
        return detail;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //eliminar producto
  Future<bool> deleteProduct(detalleid) async {
    SharedPreferences web = await SharedPreferences.getInstance();
    final response = await http.get(web.getString('WebApi') +
        "/api/BorraArticulo?DetalleID=" +
        detalleid.toString());

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
