import 'package:dislacvta/controller/detallepedidocontroller.dart';
import 'package:dislacvta/pages/ventas/printpedido.dart';
import 'package:dislacvta/pages/widgets/detallevtapedidopage_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalleVentaPedidoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetallePedidoController>(
      init: DetallePedidoController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Detalle pedido'),
            actions: [
              IconButton(
                  padding: EdgeInsets.only(
                    right: 10.0,
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 40,
                  ),
                  onPressed: () async {
                    Get.to(PrintPedidoPage());
                  }),
            ],
          ),
          body: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Importe total: \$ ${_.detallePedido.importe}',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
                Expanded(
                  child: DetalleVentaPedidoPageWidget(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
