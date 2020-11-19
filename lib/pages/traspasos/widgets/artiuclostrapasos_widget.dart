import 'package:dislacvta/controller/articulostraspasoscontroller.dart';
import 'package:dislacvta/models/articulostraspasos.dart';
import 'package:dislacvta/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class ArticulosTrapasosWidget extends StatefulWidget {
  @override
  _ArticulosTrapasosWidgetState createState() =>
      _ArticulosTrapasosWidgetState();
}

class _ArticulosTrapasosWidgetState extends State<ArticulosTrapasosWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticulosTrapasosController>(
      id: 'ArticulosTrapasos',
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_.articulos.length > 0) {
          return ListView.builder(
            itemCount: _.articulos.length,
            itemBuilder: (context, index) {
              final ArticuloTrapasos articulo = _.articulos[index];

              return Card(
                margin: EdgeInsets.all(
                  15.0,
                ),
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.all(
                      20.0,
                    ),
                    leading: Icon(Icons.crop_original, color: Colors.blue),
                    title: Text("Clave articulo: " + articulo.claveArticulo,
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text(
                          articulo.articulo,
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Divider(),
                        new Text('Unidad venta: ' + articulo.unidadVenta,
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                      ],
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            color: Colors.lightBlue,
                            onPressed: () {
                              _asyncInputDialog(context, articulo.articuloId,
                                  articulo.claveArticulo, _);
                            }),
                      ])
                ]),
              );
            },
          );
        } else {
          return Center(
            child: Text('No se encontraron resultados'),
          );
        }
      },
    );
  }

  Future<String> _asyncInputDialog(BuildContext context, int idArticulo,
      String claveArticulo, ArticulosTrapasosController _) async {
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
                'Cantidad a traspasar',
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
                  labelText: 'Escriba la cantidad',
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
                int traspasoID = await _.addArticuloTraspaso(
                    idArticulo, double.parse(unidades), claveArticulo);

                if (traspasoID > 0) {
                  Navigator.pop(context);
                  Toast.show(
                      "El producto fue agregado al traspaso " +
                          traspasoID.toString(),
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM);
                } else {
                  Toast.show("Ocurrio un erro al agregar el producto.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
