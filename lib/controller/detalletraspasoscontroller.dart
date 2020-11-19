import 'package:dislacvta/api/traspasos.dart';
import 'package:dislacvta/models/detalletraspasos.dart';
import 'package:get/get.dart';

class DetalleTraspasosController extends GetxController {
  List<DetalleTraspasos> _traspasos = [];
  bool _loading = true;

  List<DetalleTraspasos> get traspasos => _traspasos;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadDetalleTraspasos();
  }

  Future<void> loadDetalleTraspasos() async {
    final data = await TrapasosApi.instance.getDetalleTraspasos();
    this._traspasos = data;
    this._loading = false;
    update();
  }

  Future<bool> deleteDetalle(int detalleID) async {
    final data = await TrapasosApi.instance.deleteDetalle(detalleID);
    if (data) {
      loadDetalleTraspasos();
    }
    this._loading = false;
    return data;
  }
}
