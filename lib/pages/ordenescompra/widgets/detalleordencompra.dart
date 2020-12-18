import 'package:dislacvta/controller/detalleordencompra.dart';
import 'package:dislacvta/models/oderncompradetalle.dart';
import 'package:dislacvta/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class OrdenCompraDetallePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdenesCompraDetalleController>(
      id: 'OrdenDetalle',
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_.ordenes.length > 0) {
          return ListView.builder(
            itemCount: _.ordenes.length,
            itemBuilder: (context, index) {
              final ModelOrdenCompraDetalle ordenes = _.ordenes[index];

              return Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.crop_original, color: Colors.blue),
                    title: Text(ordenes.claveArticulo),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text(ordenes.nombre,
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        Divider(),
                        new Text(
                            'Cant. Solicitada: ' +
                                ordenes.unidadesSolicitadas.toString(),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              onPressed: () async {
                                _asyncInputDialog(
                                    context, ordenes.detalleOrdenId, _);
                              },
                              child: Icon(
                                Icons.receipt,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        )
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

  Future<String> _asyncInputDialog(BuildContext context, int detalleID,
      OrdenesCompraDetalleController _) async {
    String unidades = '';

    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[100],
          title: Container(
            color: colorfondo,
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: Center(
              child: Text(
                'Recepción',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Escriba la cantidad recibida',
                  hintText: '0',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                onChanged: (value) {
                  unidades = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red[900],
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.green[900],
              child: Text('Aceptar'),
              onPressed: () async {
                bool resp =
                    await _.recepcion(detalleID, double.parse(unidades));

                if (resp) {
                  Navigator.pop(context);
                  Toast.show(
                      "La recepcion fue guardada correctamente ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  Toast.show(
                      "Ocurrio un erro al intentar guardar la recepcion.",
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
