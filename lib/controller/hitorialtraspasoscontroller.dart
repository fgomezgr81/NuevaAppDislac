import 'package:dislacvta/api/traspasos.dart';

import 'package:dislacvta/models/historialtraspasos.dart';
import 'package:get/get.dart';

class HistorialTraspasosController extends GetxController {
  List<HistorialTraspasos> _historial = [];
  bool _loading = true;

  List<HistorialTraspasos> get historial => _historial;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadHistorialTraspasos();
  }

  Future<void> loadHistorialTraspasos() async {
    final data = await TrapasosApi.instance.getHistorialTraspasos();
    this._historial = data;
    this._loading = false;
    update();
  }

  Future<void> loadSearchHistorialTraspasos(int traspasoID) async {
    this._loading = true;
    final data =
        await TrapasosApi.instance.searchgetHistorialTraspasos(traspasoID);
    this._historial = data;
    this._loading = false;
    update();
  }
}
