import 'package:dislacvta/api/almacenesapi.dart';
import 'package:dislacvta/models/almacenes.dart';
import 'package:get/get.dart';

class AlmacenesController extends GetxController {
  List<ModelAlmacenes> _almacenes = [];
  bool _loading = true;

  List<ModelAlmacenes> get almacenes => _almacenes;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadAlmacenes();
  }

  Future<void> loadAlmacenes() async {
    final data = await AlmacenesApi.instance.getAlmacenes();
    this._almacenes = data;
    this._loading = false;
    update();
  }
}
