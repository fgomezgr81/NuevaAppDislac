import 'package:dislacvta/api/pedidosvtasapi.dart';
import 'package:dislacvta/controller/pedidosvtascontroller.dart';
import 'package:dislacvta/models/pedidosvtas.dart';
import 'package:dislacvta/pages/ventas/detallepedido.dart';
import 'package:dislacvta/pages/ventas/printpedidoDetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PagoPedidosWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PedidosVtasController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
            itemCount: _.pedidos.length,
            itemBuilder: (context, index) {
              final ModelPedido pedido = _.pedidos[index];
              return Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add_shopping_cart, color: Colors.blue),
                    title: Text(pedido.nombre),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text('Importe \$: ' + pedido.importe.toString(),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider(),
                        Text(
                            'Fecha : ' +
                                pedido.fecha.toString().substring(
                                    0, pedido.fecha.toString().length - 12),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider(),
                        Text('Forma cobro:' + pedido.formaCobro,
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
                              _grabarpreferences(pedido.idDocumento);
                              Get.to(DetallePedido());
                            }),
                        IconButton(
                            icon: Icon(Icons.print),
                            color: Colors.lightBlue,
                            onPressed: () {
                              //guardamos el pedido
                              _grabarpreferences(pedido.idDocumento);
                              Get.to(PrintPedidoDetailPage());
                            }),
                        IconButton(
                            icon: pedido.pagoid == 71
                                ? pedido.formapagoid == 0
                                    ? Icon(Icons.credit_card)
                                    : Icon(Icons.check)
                                : Icon(Icons.check),
                            color: pedido.pagoid == 71
                                ? pedido.formapagoid == 0
                                    ? Colors.redAccent
                                    : Colors.grey
                                : Colors.grey,
                            onPressed: () {
                              if (pedido.pagoid == 71) {
                                _asyncSimpleDialog(context, pedido.idDocumento);
                              } else {
                                _pagado(context);
                              }
                            })
                      ])
                ]),
              );
            });
      },
    );
  }

  _grabarpreferences(int pedidoID) async {
    SharedPreferences vendedor = await SharedPreferences.getInstance();
    await vendedor.setInt("PedidoID", pedidoID);
  }

  Future<void> _pagado(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: const Text('El documento ya esta pagado'),
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
                },
                child: const Text('Cheque'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  PedidosvtaApi.instance.pagarPedido(67, pedidoID, '', '');
                  Navigator.of(context).pop();
                },
                child: const Text('Contado'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  _getBanco(context, 9660, pedidoID);
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
                PedidosvtaApi.instance.pagarPedido(tipo, pedidoID, '', '');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
