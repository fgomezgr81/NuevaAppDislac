import 'package:dislacvta/controller/almacenescontroller.dart';
import 'package:dislacvta/pages/traspasos/sendtraspasos_page.dart';
import 'package:dislacvta/utils/constantes.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _origen;
int _destino;

class TrapasosPage extends StatefulWidget {
  @override
  _TrapasosPageState createState() => _TrapasosPageState();
}

class _TrapasosPageState extends State<TrapasosPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlmacenesController>(
      init: AlmacenesController(),
      builder: (_) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton(
                  hint: Text('Almacen origen'), // Not necessary for Option 1
                  value: _origen,
                  onChanged: (newValue) {
                    setState(() {
                      _origen = newValue;
                    });
                  },
                  items: _.almacenes.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location.almacen),
                      value: location.almacenId,
                    );
                  }).toList(),
                ),
                DropdownButton(
                  hint: Text('Almacen destino'), // Not necessary for Option 1
                  value: _destino,
                  onChanged: (newValue) {
                    setState(() {
                      _destino = newValue;
                    });
                  },
                  items: _.almacenes.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location.almacen),
                      value: location.almacenId,
                    );
                  }).toList(),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(
                    10.0,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: colorbase)),
                  color: colorbase,
                  onPressed: () async {
                    if (_origen != _destino) {
                      _grabarAlmacenes(_origen, _destino);
                      Get.to(SendTrapasos());
                    } else {
                      Dialogs.popupDialog(context, "Almacenes",
                          "Los alamcenes seleccionados no pueden ser el mismo.");
                    }
                  },
                  child: Text(
                    'Continuar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
          ),
        );
      },
    );
  }

  _grabarAlmacenes(int origen, int destino) async {
    SharedPreferences config = await SharedPreferences.getInstance();
    config.setInt('AlmacenOrigenID', origen);
    config.setInt('AlmacenDestinoID', destino);
    config.setInt('TraspasoID', 0);
  }
}
