//import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dislacvta/api/pedidosvtasapi.dart';
import 'package:dislacvta/controller/pedidoscreditocontroller.dart';
import 'package:dislacvta/models/modelprintdetalle.dart';
import 'package:dislacvta/models/pedidosvtas.dart';
import 'package:dislacvta/pages/ventas/detallepedido.dart';
import 'package:dislacvta/pages/ventas/printpedidoDetail.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_zsdk/flutter_zsdk.dart';

class PedidosCreditoVtasWidget extends StatefulWidget {
  @override
  _PedidosCreditoVtasWidgetState createState() =>
      _PedidosCreditoVtasWidgetState();
}

class _PedidosCreditoVtasWidgetState extends State<PedidosCreditoVtasWidget> {
  //List<ZebraBluetoothDevice> _devices = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PedidosCreditoVtasController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_.pedidos.length > 0) {
          return ListView.builder(
            itemCount: _.pedidos.length,
            itemBuilder: (context, index) {
              final ModelPedido pedidos = _.pedidos[index];
              return Card(
                margin: EdgeInsets.all(15.0),
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.all(
                      10.0,
                    ),
                    leading: Icon(Icons.add_shopping_cart, color: Colors.blue),
                    title: Text(pedidos.nombre),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text('Importe \$: ' + pedidos.importe.toString(),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider(),
                        Text(
                            'Fecha : ' +
                                pedidos.fecha.toString().substring(
                                    0, pedidos.fecha.toString().length - 12),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider(),
                        Text('Forma de cobro:' + pedidos.formaCobro,
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider()
                      ],
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            color: Colors.amber,
                            onPressed: () {
                              //guardamos el pedido
                              _grabarpreferences(pedidos.idDocumento);
                              Get.to(DetallePedido());
                            }),
                        IconButton(
                            icon: Icon(Icons.print),
                            color: Colors.lightBlue,
                            onPressed: () {
                              //guardamos el pedido
                              _grabarpreferences(pedidos.idDocumento);
                              Get.to(PrintPedidoDetailPage());
                            }),
                        IconButton(
                            icon: pedidos.pagoid == 71
                                ? pedidos.formapagoid == 0
                                    ? Icon(Icons.credit_card)
                                    : Icon(Icons.check)
                                : Icon(Icons.check),
                            color: pedidos.pagoid == 71
                                ? pedidos.formapagoid == 0
                                    ? Colors.redAccent
                                    : Colors.grey
                                : Colors.grey,
                            onPressed: () {
                              if (pedidos.pagoid == 71) {
                                _asyncSimpleDialog(
                                    context, pedidos.idDocumento);
                              } else {
                                // _pagado(context);
                              }
                            })
                      ])
                ]),
              );
            },
          );
        } else {
          return Center(
              child: Text(
            'No se encontraron registros',
            style: TextStyle(
              color: Colors.red,
            ),
          ));
        }
      },
    );
  }

  _grabarpreferences(int pedidoID) async {
    SharedPreferences vendedor = await SharedPreferences.getInstance();
    await vendedor.setInt("PedidoID", pedidoID);
  }

  Future<void> _asyncSimpleDialog(BuildContext context, int pedidoID) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Seleccione una opcion'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  _getBanco(context, 68, pedidoID);
                  //Navigator.of(context).pop();
                },
                child: const Text('Cheque'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  PedidosvtaApi.instance.pagarPedido(67, pedidoID, '', '');
                  Navigator.of(context).pop();
                },
                child: const Text('Efectivo'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  _getBanco(context, 9660, pedidoID);
                  //Navigator.of(context).pop();
                },
                child: const Text('Transferencia'),
              ),
            ],
          );
        });
  }

  Future<String> _getBanco(BuildContext context, int tipo, int pedidoID) async {
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
              onPressed: () {
                PedidosvtaApi.instance
                    .pagarPedido(tipo, pedidoID, teamName, referencia);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
