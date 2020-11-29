import 'package:dislacvta/controller/invetarioscontroller.dart';
import 'package:dislacvta/models/modelinventarios.dart';
import 'package:dislacvta/pages/inventarios/detalleinventarios.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventariosWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventariosController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_.detail.length > 0) {
          return ListView.builder(
            itemCount: _.detail.length,
            itemBuilder: (context, index) {
              final ModelInventarios inventario = _.detail[index];

              return Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.crop_original, color: Colors.blue),
                    title: Text(inventario.almacen),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text(
                            'Fecha: ' +
                                inventario.fecha.toString().substring(0, 11),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        Divider(),
                        Text('Estatus: ' + inventario.estatus,
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        Divider(),
                        Row(
                          children: [
                            FlatButton(
                              onPressed: () async {
                                SharedPreferences config =
                                    await SharedPreferences.getInstance();
                                config.setInt(
                                    'InventarioID', inventario.inventarioID);

                                Get.to(DetalleInventairosPage());
                              },
                              child: Icon(
                                Icons.remove_red_eye,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Detalle',
                              style: TextStyle(
                                color: Colors.red[200],
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
