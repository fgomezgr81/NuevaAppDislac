import 'package:dislacvta/controller/ordenescompracontroller.dart';
import 'package:dislacvta/models/ordenescompra.dart';
import 'package:dislacvta/pages/ordenescompra/detalleordencompra.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdenesCompraWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdenesCompraController>(
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
              final ModelOrdenCompra ordenes = _.ordenes[index];

              return Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.crop_original, color: Colors.blue),
                    title: Text(ordenes.folioOc),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text(ordenes.proveedor,
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        Divider(),
                        new Text(
                            'Fecha OC: ' +
                                ordenes.fechaOc.toString().substring(0, 11),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ordenes.estatus == "A"
                                ? FlatButton(
                                    onPressed: null,
                                    child: Icon(
                                      Icons.check_box,
                                      color: Colors.green[700],
                                    ),
                                  )
                                : FlatButton(
                                    onPressed: () async {
                                      _saveOrdenCompra(ordenes.ordenID);
                                      Get.to(OrdenCompraDetallePage());
                                    },
                                    child: Icon(
                                      Icons.receipt,
                                      color: Colors.red[700],
                                    ),
                                  )
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

  _saveOrdenCompra(int ordenID) async {
    SharedPreferences config = await SharedPreferences.getInstance();
    config.setInt('OrdenCompraID', ordenID);
  }
}
