import 'package:dislacvta/controller/detalleinventariocontroller.dart';
import 'package:dislacvta/models/detalleinventario.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalleInventarioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetalleInventarioController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_.detalleInventario.length > 0) {
          return ListView.builder(
            itemCount: _.detalleInventario.length,
            itemBuilder: (context, index) {
              final ModelDetalleInventario inventario =
                  _.detalleInventario[index];

              return Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.crop_original, color: Colors.blue),
                    title: Text(inventario.codigo),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text(inventario.articulo,
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        Divider(),
                        Text('Unidades: ' + inventario.unidades.toString(),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        Divider(),
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
              'No se encontraron resultados',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          );
        }
      },
    );
  }
}
