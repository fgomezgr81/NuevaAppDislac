import 'package:dislacvta/controller/detalletraspasoscontroller.dart';
import 'package:dislacvta/models/detalletraspasos.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalleTraspasoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetalleTraspasosController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: _.traspasos.length,
          itemBuilder: (context, index) {
            final DetalleTraspasos traspaso = _.traspasos[index];

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
                  title: Text("Clave articulo:" + traspaso.claveArticulo),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      new Text(
                        traspaso.descripcion,
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      Divider(),
                      new Text(
                        'Unidades: ' + traspaso.unidades.toString(),
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 30,
                          ),
                          color: Colors.red,
                          onPressed: () async {
                            bool resp = await _
                                .deleteDetalle(traspaso.trapasoDetalleID);
                            if (resp) {
                              Dialogs.popupDialog(context, "Detalle traspaso",
                                  "Se elimino correctamente el registro, del trapaso.");
                            }
                          }),
                    ],
                  ),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}
