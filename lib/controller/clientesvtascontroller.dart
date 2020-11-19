import 'package:dislacvta/api/clientesvtasapi.dart';
import 'package:dislacvta/models/clientesvtas.dart';
import 'package:get/get.dart';

class ClientesVtasController extends GetxController {
  List<Clientesvtas> _clientes = [];
  bool _loading = true;

  List<Clientesvtas> get clientes => _clientes;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadClientes();
  }

  Future<void> loadClientes() async {
    final data = await ClientesvtaApi.instance.getClientes();
    this._clientes = data;
    this._loading = false;
    update(['Clientesvtas']);
  }

  Future<void> loadClientesSearch(String nameCliente) async {
    final data = await ClientesvtaApi.instance.getClientesSearch(nameCliente);
    this._clientes = data;
    this._loading = false;
    update(['Clientesvtas']);
  }
}
