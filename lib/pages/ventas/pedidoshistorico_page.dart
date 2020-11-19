import 'package:dislacvta/controller/pedidoshistoricocontroller.dart';
import 'package:dislacvta/pages/widgets/pedidovtashistorico_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController editingController;

class PedidosHistoricoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PedidosHistoricoVtasController>(
      init: PedidosHistoricoVtasController(),
      builder: (_) {
        return Scaffold(
            body: Container(
                child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: editingController,
                onChanged: (value) {
                  _.loadPedidosSearch(value);
                },
                decoration: InputDecoration(
                    labelText: "Buscar",
                    hintText: "Buscar",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: PedidosHistoricoVtasWidget(),
            )
          ],
        )));
      },
    );
  }
}
