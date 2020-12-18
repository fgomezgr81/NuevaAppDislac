import 'package:dislacvta/api/productoclienteapi.dart';
import 'package:dislacvta/controller/productosclientecontroller.dart';
import 'package:dislacvta/pages/ventas/detallepedido.dart';
import 'package:dislacvta/pages/ventas/detallepedidovta.dart';
import 'package:dislacvta/pages/ventas/homevtas_page.dart';
import 'package:dislacvta/pages/ventas/printpedido.dart';
import 'package:dislacvta/pages/widgets/producto_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ProductosClienteVtasPage extends StatefulWidget {
  @override
  _ProductosClienteVtasPageState createState() =>
      _ProductosClienteVtasPageState();
}

class _ProductosClienteVtasPageState extends State<ProductosClienteVtasPage> {
  Future<int> getPedidoID() async {
    SharedPreferences config = await SharedPreferences.getInstance();
    return config.getInt('PedidoID');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductoClienteController>(
        init: ProductoClienteController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Productos',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      size: 30,
                    ),
                    onPressed: () async {
                      int pedidoID = await getPedidoID();
                      if (pedidoID > 0) {
                        Get.to(DetalleVentaPedido());
                      } else {
                        _ackAlert(context);
                      }
                    }),
                IconButton(
                    icon: Icon(
                      Icons.save,
                      size: 30,
                    ),
                    onPressed: () async {
                      int pedidoID = await getPedidoID();
                      if (pedidoID > 0) {
                        _asyncSimpleDialog(context);
                      } else {
                        _ackAlert(context);
                      }
                    }),
                IconButton(
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    icon: Icon(
                      Icons.supervisor_account,
                      size: 30,
                    ),
                    onPressed: () async {
                      SharedPreferences config =
                          await SharedPreferences.getInstance();
                      config.setInt('ClienteID', 0);
                      Get.off(HomeVtasPage());
                    })
              ],
            ),
            body: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GetBuilder<ProductoClienteController>(
                      builder: (_) {
                        return Text(_.cliente,
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black));
                      },
                    ),
                  ),
                  Expanded(
                    child: ProductoWidget(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //alertas
  Future<void> _asyncSimpleDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Seleccione una opcion'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  bool resp = await ProductosClienteApi.instance
                      .cerrarPedido(71, '', '');
                  if (resp) {
                    Toast.show("El pedido fue guardado exitosamente.", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Get.offAll(PrintPedidoPage());
                  } else {
                    Toast.show(
                        "Ocurrio un error al querer cerrar el pedido.", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                },
                child: const Text('Credito'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _getBanco(context, 68);
                },
                child: const Text('Cheque'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  bool resp = await ProductosClienteApi.instance
                      .cerrarPedido(67, '', '');
                  if (resp) {
                    Toast.show("El pedido fue guardado exitosamente.", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Get.offAll(PrintPedidoPage());
                  } else {
                    Toast.show(
                        "Ocurrio un error al querer cerrar el pedido.", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                },
                child: const Text('Efectivo'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _getBanco(context, 9660);
                },
                child: const Text('Transferencia'),
              ),
            ],
          );
        });
  }

  Future<String> _getBanco(BuildContext context, int tipo) async {
    String teamName = '';
    String referencia = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Banco'),
          content:
              new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            TextField(
              decoration:
                  InputDecoration(labelText: 'Banco', hintText: 'Bancomer'),
              onChanged: (value) {
                teamName = value;
              },
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Referencia', hintText: '001289'),
              onChanged: (value) {
                referencia = value;
              },
            )
          ]),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () async {
                bool resp = await ProductosClienteApi.instance
                    .cerrarPedido(tipo, teamName, referencia);
                if (resp) {
                  Toast.show("El pedido fue guardado exitosamente.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  Get.offAll(PrintPedidoPage());
                } else {
                  Toast.show(
                      "Ocurrio un error al querer cerrar el pedido.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cierre pedido'),
          content: const Text('No ha agregado ningun producto al pedido'),
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
