import 'package:dislacvta/api/productoclienteapi.dart';
import 'package:dislacvta/models/detallepedidovtas.dart';
import 'package:get/get.dart';

class DetallePedidoController extends GetxController {
  DetallePedidoVtas _detallePedido = new DetallePedidoVtas();
  bool _loading = true;

  DetallePedidoVtas get detallePedido => _detallePedido;
  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    this.loadDetallePedido();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> loadDetallePedido() async {
    final data = await ProductosClienteApi.instance.getDetallePedido();
    this._detallePedido = data;
    this._loading = false;
    update();
  }
}
