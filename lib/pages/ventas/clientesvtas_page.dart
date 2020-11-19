import 'package:dislacvta/controller/clientesvtascontroller.dart';
import 'package:dislacvta/pages/widgets/clientes_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientesVtasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController editingController;

    return GetBuilder<ClientesVtasController>(
      init: ClientesVtasController(),
      builder: (_) {
        return Scaffold(
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
                      _.loadClientesSearch(value);
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
                  child: ClientesWidget(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
