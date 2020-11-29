import 'package:dislacvta/controller/ordenescompracontroller.dart';
import 'package:dislacvta/pages/login_page.dart';
import 'package:dislacvta/pages/orcenescompra/widgets/ordenescompra_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdenesCompraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdenesCompraController>(
      init: OrdenesCompraController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Ordenes de compra'),
            actions: [
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
          body: OrdenesCompraWidget(),
        );
      },
    );
  }
}
