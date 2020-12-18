import 'package:dislacvta/controller/detallepedidocontroller.dart';
import 'package:dislacvta/pages/widgets/detallevtapedido_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class DetalleVentaPedido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetallePedidoController>(
      init: DetallePedidoController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Detalle pedido'),
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
                  child: DetalleVentaPedidoWidget(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
