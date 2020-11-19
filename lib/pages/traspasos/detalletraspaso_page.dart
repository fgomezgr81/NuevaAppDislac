import 'package:dislacvta/controller/detalletraspasoscontroller.dart';
import 'package:dislacvta/pages/traspasos/widgets/detalletraspaso_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalleTraspasoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetalleTraspasosController>(
      init: DetalleTraspasosController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Detalle traspaso'),
          ),
          body: DetalleTraspasosWidget(),
        );
      },
    );
  }
}
