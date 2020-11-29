import 'package:dislacvta/controller/detalleinventariocontroller.dart';
import 'package:dislacvta/pages/inventarios/widgets/detalleinventario_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalleInventairosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetalleInventarioController>(
      init: DetalleInventarioController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Detalle inventario'),
          ),
          body: DetalleInventarioWidget(),
        );
      },
    );
  }
}
