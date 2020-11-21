import 'package:dislacvta/controller/cortediacontroller.dart';
import 'package:dislacvta/pages/widgets/cortedia_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalleCorte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CorteDiaController>(
        init: CorteDiaController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Corte del dia'),
            ),
            body: CorteDiaWidget(),
          );
        });
  }
}
