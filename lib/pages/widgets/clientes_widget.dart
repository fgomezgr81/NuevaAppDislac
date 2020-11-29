import 'package:dislacvta/controller/clientesvtascontroller.dart';
import 'package:dislacvta/models/clientesvtas.dart';
import 'package:dislacvta/pages/ventas/pagarpedidos.dart';
import 'package:dislacvta/pages/ventas/productosvta_page.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientesVtasController>(
      id: 'Clientesvtas',
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_.clientes.length > 0) {
          return ListView.builder(
            itemCount: _.clientes.length,
            itemBuilder: (context, index) {
              final Clientesvtas clientes = _.clientes[index];

              return ListTile(
                title: Text(clientes.clienteId.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    )),
                subtitle: Text(
                  clientes.nombre,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                leading: Icon(
                  Icons.face,
                  color: Colors.blue[500],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue[400],
                ),
                onTap: () {
                  if (clientes.estatus == "A") {
                    _setClienteID(
                        clientes.clienteId.toString(), clientes.nombre);

                    if (clientes.credito == 0) {
                      Get.to(ProductosClienteVtasPage());
                    } else {
                      _asyncConfirmDialog(context);
                    }
                  } else {
                    Dialogs.alertCredito(context);
                  }
                },
              );
            },
          );
        } else {
          return Center(
              child: Text(
            'No se encontraron registros',
            style: TextStyle(
              color: Colors.red,
            ),
          ));
        }
      },
    );
  }

  _setClienteID(String clienteid, String cliente) async {
    SharedPreferences vendedor = await SharedPreferences.getInstance();
    await vendedor.setInt("ClienteID", int.parse(clienteid));
    await vendedor.setString("Cliente", cliente);
    await vendedor.setInt("PedidoID", 0);
  }

  //definicion de future alertas
  Future<void> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Opciones'),
          content: const Text(
              'El cliente tiene pedidos a credito, desea ir a realizar el pago de estos.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Nuevo pedidos'),
              onPressed: () {
                Get.to(ProductosClienteVtasPage());
              },
            ),
            FlatButton(
              child: const Text('Pagar pedidos'),
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(PagarPedidos());
              },
            )
          ],
        );
      },
    );
  }
}
