import 'package:dislacvta/api/traspasos.dart';

import 'package:dislacvta/models/articulostraspasos.dart';
import 'package:get/get.dart';

class ArticulosTrapasosController extends GetxController {
  List<ArticuloTrapasos> _articulos = [];
  bool _loading = false;

  List<ArticuloTrapasos> get articulos => _articulos;
  bool get loading => _loading;

  @override
  void onReady() {
    super.onReady();
    this.loadArticulos('');
  }

  Future<void> loadArticulos(String nombre) async {
    this._loading = true;
    final data = await TrapasosApi.instance.getArticulosTraspasos(nombre);
    this._articulos = data;
    this._loading = false;
    update();
  }

  Future<int> addArticuloTraspaso(
      int articuloID, double unidades, String claveArticulo) async {
    this._loading = true;
    final resp = await TrapasosApi.instance
        .addtraspaso(unidades, articuloID, claveArticulo);

    this._loading = false;
    return resp;
  }

  Future<bool> cerrarTraspaso() async {
    this._loading = true;
    final resp = await TrapasosApi.instance.cerrarTraspaso();

    this._loading = false;
    return resp;
  }
}
