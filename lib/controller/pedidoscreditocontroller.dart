import 'package:dislacvta/api/pedidosvtasapi.dart';
import 'package:dislacvta/models/pedidosvtas.dart';
import 'package:get/get.dart';

class PedidosCreditoVtasController extends GetxController {
  List<ModelPedido> _pedidos = [];
  bool _loading = true;

  List<ModelPedido> get pedidos => _pedidos;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadPedidos();
  }

  Future<void> loadPedidos() async {
    final data = await PedidosvtaApi.instance.getPedidosCredito();
    this._pedidos = data;
    this._loading = false;
    update();
  }

  Future<void> loadPedidosSearch(String nameCliente) async {
    final data = await PedidosvtaApi.instance.searchPedidosCredito(nameCliente);
    this._pedidos = data;
    this._loading = false;
    update();
  }
}
