import 'package:dislacvta/controller/articulosinvetarioscontroller.dart';
import 'package:dislacvta/pages/inventarios/detalleinventarios.dart';
import 'package:dislacvta/pages/inventarios/homeinvetarios.dart';
import 'package:dislacvta/pages/inventarios/widgets/artiuclostrapasos_widget.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class InventoryPage extends StatefulWidget {
  @override
  _SendInventoryPageState createState() => _SendInventoryPageState();
}

class _SendInventoryPageState extends State<InventoryPage> {
  TextEditingController editingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticulosInventariosController>(
      init: ArticulosInventariosController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Inventario'),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    size: 20,
                  ),
                  onPressed: () async {
                    int traspasoID = await getDetalleTrapaso();
                    if (traspasoID > 0) {
                      Get.to(DetalleInventairosPage());
                    } else {
                      _ackAlert(context);
                    }
                  }),
              IconButton(
                  icon: Icon(
                    Icons.keyboard_return,
                    size: 20,
                  ),
                  onPressed: () async {
                    Get.back();
                  }),
              IconButton(
                  icon: Icon(
                    Icons.save,
                    size: 20,
                  ),
                  onPressed: () async {
                    int pedidoID = await getDetalleTrapaso();
                    if (pedidoID > 0) {
                      bool resp = await _.cerrarInventario();
                      if (resp) {
                        Toast.show(
                            "El traspaso se finalizo correctamente.", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        Get.off(HomeInventarios());
                      } else {
                        Dialogs.popupDialog(context, 'Traspasos',
                            'Ocurrio un error al querer finalizar el traspaso.');
                      }
                    } else {
                      _ackAlert(context);
                    }
                  }),
            ],
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: editingController,
                    onChanged: (value) {
                      _.loadArticulos(value);
                    },
                    decoration: InputDecoration(
                        labelText: "Escriba la clave del articulo",
                        hintText: "Escriba la clave del articulo",
                        prefixIcon: InkWell(
                            onTap: () => _scanPhoto(_),
                            child: Icon(Icons.settings_overscan)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: ArticulosInventariosWidget(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future _scanPhoto(ArticulosInventariosController _) async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancelar", true, ScanMode.DEFAULT);
    if (barcode != '-1') {
      _.loadArticulos(barcode);
      setState(() {
        this.editingController.text = barcode;
      });
    }
  }

  Future<int> getDetalleTrapaso() async {
    SharedPreferences config = await SharedPreferences.getInstance();
    return config.getInt('InventarioID');
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inventarios'),
          content: const Text('No han agregados productos a inventariar'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
