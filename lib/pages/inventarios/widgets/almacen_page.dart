import 'package:dislacvta/controller/almacenescontroller.dart';
import 'package:dislacvta/pages/inventarios/searchinventory.dart';
import 'package:dislacvta/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _origen;

class AlmacenPage extends StatefulWidget {
  @override
  _AlmacenPagePageState createState() => _AlmacenPagePageState();
}

class _AlmacenPagePageState extends State<AlmacenPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlmacenesController>(
      init: AlmacenesController(),
      builder: (_) {
        return Scaffold(
          body: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      child: new Text(
                        location.almacen,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      value: location.almacenId,
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      color: Colors.red,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Canclear',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
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
                        _grabarAlmacenes(_origen);
                        Get.to(InventoryPage());
                      },
                      child: Text(
                        'Continuar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _grabarAlmacenes(int origen) async {
    SharedPreferences config = await SharedPreferences.getInstance();
    config.setInt('AlmacenID', origen);
    config.setInt('InventarioID', 0);
  }
}
