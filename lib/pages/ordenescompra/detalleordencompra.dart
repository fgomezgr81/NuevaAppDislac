import 'package:dislacvta/controller/detalleordencompra.dart';
import 'package:dislacvta/pages/ordenescompra/homeordenescompra.dart';
import 'package:dislacvta/pages/ordenescompra/widgets/detalleordencompra.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class OrdenCompraDetallePage extends StatefulWidget {
  @override
  _OrdenCompraDetallePageState createState() => _OrdenCompraDetallePageState();
}

class _OrdenCompraDetallePageState extends State<OrdenCompraDetallePage> {
  TextEditingController editingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdenesCompraDetalleController>(
      init: OrdenesCompraDetalleController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Orden de compra'),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.save,
                    size: 20,
                  ),
                  onPressed: () async {
                    bool resp = await _.cerrarRecepcion();
                    if (resp) {
                      Toast.show(
                          "El traspaso se finalizo correctamente.", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Get.off(OrdenesCompraPage());
                    } else {
                      Dialogs.popupDialog(context, 'Traspasos',
                          'Ocurrio un error al querer finalizar el traspaso.');
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
                      _.searchOrdenesCompra(value);
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
                  child: OrdenCompraDetallePageWidget(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future _scanPhoto(OrdenesCompraDetalleController _) async {
    String respuesta = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancelar", true, ScanMode.DEFAULT);
    if (respuesta != '-1') {
      _.searchOrdenesCompra(respuesta);
    }
  }
}
