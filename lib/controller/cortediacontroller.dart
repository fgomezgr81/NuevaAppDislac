import 'package:dislacvta/api/cortedeldia.dart';
import 'package:dislacvta/models/corte.dart';
import 'package:get/get.dart';

class CorteDiaController extends GetxController {
  List<CorteDia> _corte = [];
  bool _loading = true;

  List<CorteDia> get corte => _corte;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadCorte();
  }

  Future<void> loadCorte() async {
    final data = await CorteApi.instance.fetchgetCortePost();
    this._corte = data;
    this._loading = false;
    update();
  }
}
