import 'package:dislacvta/controller/pedidosvtascontroller.dart';
import 'package:dislacvta/pages/widgets/pagopedidos_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PagarPedidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController editingController;

    return GetBuilder<PedidosVtasController>(
      init: PedidosVtasController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Pago del pedidos'),
          ),
          body: Container(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: editingController,
                    onChanged: (value) {
                      _.searchgetPagoPedidos(value);
                    },
                    decoration: InputDecoration(
                        labelText: "Buscar",
                        hintText: "Buscar",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: PagoPedidosWidget(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
