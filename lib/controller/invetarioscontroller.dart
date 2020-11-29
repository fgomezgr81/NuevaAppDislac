import 'package:dislacvta/api/invetariosapi.dart';
import 'package:dislacvta/models/modelinventarios.dart';
import 'package:get/get.dart';

class InventariosController extends GetxController {
  List<ModelInventarios> _detail = [];
  bool _loading = true;

  List<ModelInventarios> get detail => _detail;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadDetailInvetory();
  }

  Future<void> loadDetailInvetory() async {
    final data = await InvetariosApi.instance.getInventarios();
    this._detail = data;
    this._loading = false;
    update();
  }
}
