import 'package:dislacvta/controller/invetarioscontroller.dart';
import 'package:dislacvta/pages/inventarios/widgets/almacen_page.dart';
import 'package:dislacvta/pages/inventarios/widgets/inventarios_widget.dart';
import 'package:dislacvta/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeInventarios extends StatefulWidget {
  @override
  _HomeInventariosState createState() => _HomeInventariosState();
}

class _HomeInventariosState extends State<HomeInventarios> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventariosController>(
      init: InventariosController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Inventario'),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.inventory,
                    size: 30,
                    color: Colors.deepPurple[400],
                  ),
                  onPressed: () {
                    _shoDailog(context);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 30,
                  ),
                  onPressed: () {
                    Get.off(LoginPage());
                  })
            ],
          ),
          body: InventariosWidget(),
        );
      },
    );
  }

  void _shoDailog(context) {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: Text('Seleccione el almacen'),
            content: AlmacenPage(),
          );
        });
  }
}
