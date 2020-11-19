import 'package:dislacvta/controller/hitorialtraspasoscontroller.dart';
import 'package:dislacvta/models/historialtraspasos.dart';
import 'package:dislacvta/pages/traspasos/detalletraspaso_page.dart';
import 'package:dislacvta/pages/traspasos/sendtraspasos_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistorialTrapasosWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistorialTraspasosController>(builder: (_) {
      if (_.loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return ListView.builder(
        itemCount: _.historial.length,
        itemBuilder: (context, index) {
          final HistorialTraspasos historial = _.historial[index];

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
                title:
                    Text("Num. traspaso: " + historial.traspasoId.toString()),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(),
                    new Text(
                      'Alm. Origen \$: ' + historial.almacenOrigen,
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Divider(),
                    new Text(
                      'Alm. Destino: ' + historial.almacenDestino,
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    Divider(),
                    historial.estatus == 'P'
                        ? Text('Estatus: Pendiente',
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent))
                        : Text('Estatus: Aplicado',
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                historial.estatus == 'P'
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.lightBlue,
                        onPressed: () async {
                          await _saveTraspasos(
                              historial.traspasoId,
                              historial.almacenOrigenId,
                              historial.almacenDestinoId);
                          Get.to(SendTrapasos());
                        })
                    : Text(''),
                IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    color: Colors.lightBlue,
                    onPressed: () async {
                      await _saveTraspaso(historial.traspasoId);
                      Get.to(DetalleTraspasoPage());
                    }),
              ])
            ]),
          );
        },
      );
    });
  }

  _saveTraspaso(traspasoId) async {
    SharedPreferences config = await SharedPreferences.getInstance();
    config.setInt('TraspasoID', traspasoId);
  }

  _saveTraspasos(int traspasoId, int origen, int destino) async {
    SharedPreferences config = await SharedPreferences.getInstance();
    config.setInt('TraspasoID', traspasoId);
    config.setInt('AlmacenOrigenID', origen);
    config.setInt('AlmacenDestinoID', destino);
  }
}
