import 'package:dislacvta/api/invetariosapi.dart';
import 'package:dislacvta/api/traspasos.dart';
import 'package:dislacvta/controller/invetarioscontroller.dart';

import 'package:dislacvta/models/articulostraspasos.dart';
import 'package:get/get.dart';

class ArticulosInventariosController extends GetxController {
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

  Future<int> addArticuloInventario(
      int articuloID, double unidades, String claveArticulo) async {
    this._loading = true;
    final resp = await InvetariosApi.instance
        .addInventario(articuloID, unidades, claveArticulo);

    this._loading = false;
    return resp;
  }

  Future<bool> cerrarInventario() async {
    this._loading = true;
    final resp = await InvetariosApi.instance.cerrarInventario();
    InventariosController inv = new InventariosController();
    inv.loadDetailInvetory();
    this._loading = false;
    return resp;
  }
}
