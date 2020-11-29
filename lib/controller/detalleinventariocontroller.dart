import 'package:dislacvta/api/invetariosapi.dart';
import 'package:dislacvta/models/detalleinventario.dart';
import 'package:get/get.dart';

class DetalleInventarioController extends GetxController {
  List<ModelDetalleInventario> _detalleInventario =
      new List<ModelDetalleInventario>();
  bool _loading = true;

  List<ModelDetalleInventario> get detalleInventario => _detalleInventario;
  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    this.loadDetalleInventario();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> loadDetalleInventario() async {
    final data = await InvetariosApi.instance.getDetalleInventario();
    this._detalleInventario = data;
    this._loading = false;
    update();
  }
}
