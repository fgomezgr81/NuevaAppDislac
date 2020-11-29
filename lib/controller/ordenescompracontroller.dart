import 'package:dislacvta/api/ordenescompraapi.dart';
import 'package:dislacvta/models/ordenescompra.dart';
import 'package:get/get.dart';

class OrdenesCompraController extends GetxController {
  List<ModelOrdenCompra> _ordenes = [];
  bool _loading = true;

  List<ModelOrdenCompra> get ordenes => _ordenes;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadOrdenesCompra();
  }

  Future<void> loadOrdenesCompra() async {
    final data = await OrdenesCompraApi.instance.getOrdnesCompra();
    this._ordenes = data;
    this._loading = false;
    update();
  }
}
