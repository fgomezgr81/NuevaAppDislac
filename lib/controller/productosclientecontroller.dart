import 'package:dislacvta/api/productoclienteapi.dart';
import 'package:dislacvta/models/productocliente.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductoClienteController extends GetxController {
  List<ProductoCliente> _producto = [];
  bool _loading = true;
  String _cliente = "";

  List<ProductoCliente> get producto => _producto;
  bool get loading => _loading;
  String get cliente => _cliente;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    this.getClienteNombre();
    this.loadProductoClientes();
  }

  Future<void> loadProductoClientes() async {
    final data = await ProductosClienteApi.instance.getProductoCliente();
    this._producto = data;
    this._loading = false;
    update();
  }

  Future<void> getClienteNombre() async {
    SharedPreferences config = await SharedPreferences.getInstance();
    this._cliente = config.getString('Cliente');
  }
}
