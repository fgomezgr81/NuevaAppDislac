import 'package:dislacvta/api/pedidosvtasapi.dart';
import 'package:dislacvta/controller/detallepedidocontroller.dart';
import 'package:dislacvta/models/detallepedidovtas.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class DetalleVentaPedidoPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetallePedidoController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final DetallePedidoVtas detalle = _.detallePedido;
        if (detalle.detalleArticulos.length > 0) {
          return ListView.builder(
            itemCount: detalle.detalleArticulos.length,
            itemBuilder: (context, index) {
              final DetalleArticulo articulo = detalle.detalleArticulos[index];

              return Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.crop_original, color: Colors.blue),
                    title: Text(articulo.articulo),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text('Cantidad: ' + articulo.unidades.toString(),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        Divider(),
                        new Text('Importe \$: ' + articulo.importe.toString(),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider(),
                        FlatButton(
                          onPressed: () async {
                            // bool resp =
                            //     await _.deleteProducto(articulo.detalleId);
                            // if (resp) {
                            //   Toast.show(
                            //       "El producto fue eliminado correctamente del pedido.",
                            //       context,
                            //       duration: Toast.LENGTH_LONG,
                            //       gravity: Toast.BOTTOM);
                            // } else {
                            //   Toast.show(
                            //       "Error al eliminar el producto del pedido.",
                            //       context,
                            //       duration: Toast.LENGTH_LONG,
                            //       gravity: Toast.BOTTOM);
                            // }
                            _asyncInputDialog(
                                context, articulo.detalleId, articulo.unidades);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.remove_shopping_cart,
                                semanticLabel: "Devolver",
                              ),
                              Text(
                                'Devolver',
                                style: TextStyle(
                                  color: Colors.red[200],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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

  Future<String> _asyncInputDialog(
      BuildContext context, int idDetalle, double unidades) async {
    double teamNames = 0;

    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Devolucion'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Escriba la cantidad a devolver', hintText: '0'),
                onChanged: (value) {
                  teamNames = double.parse(value);
                },
              )
            ],
          ),
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
                Navigator.of(context).pop();
                bool resp = await PedidosvtaApi.instance
                    .devolucion(idDetalle, teamNames);

                if (resp) {
                  Toast.show("La devolucion se realizo correctamente", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  Toast.show(
                      'Ocurrio un error al querer registrar la devolucion.',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
