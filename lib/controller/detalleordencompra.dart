import 'package:dislacvta/api/ordenescompraapi.dart';
import 'package:dislacvta/models/oderncompradetalle.dart';
import 'package:get/get.dart';

class OrdenesCompraDetalleController extends GetxController {
  List<ModelOrdenCompraDetalle> _ordenes = [];
  bool _loading = true;

  List<ModelOrdenCompraDetalle> get ordenes => _ordenes;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadOrdenesCompra();
  }

  Future<void> loadOrdenesCompra() async {
    final data = await OrdenesCompraApi.instance.getOrdnesCompraDetalle();
    this._ordenes = data;
    this._loading = false;
    update(['OrdenDetalle']);
  }

  Future<void> searchOrdenesCompra(String clave) async {
    final data =
        await OrdenesCompraApi.instance.searchOrdnesCompraDetalle(clave);
    this._ordenes = data;
    this._loading = false;
    update(['OrdenDetalle']);
  }

  Future<bool> recepcion(int detalleID, double cantidad) async {
    bool data = await OrdenesCompraApi.instance.recepcion(detalleID, cantidad);
    return data;
  }

  Future<bool> cerrarRecepcion() async {
    return await OrdenesCompraApi.instance.cerrarrRecepcion();
  }
}
