import 'package:dislacvta/api/productoclienteapi.dart';
import 'package:dislacvta/controller/productosclientecontroller.dart';
import 'package:dislacvta/models/productocliente.dart';
import 'package:dislacvta/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class ProductoWidget extends StatefulWidget {
  @override
  _ProductoWidgetState createState() => _ProductoWidgetState();
}

class _ProductoWidgetState extends State<ProductoWidget> {
  int pedidoID = 0;
  int clienteID = 0;
  double cantidad = 0;
  double cambio = 0;
  int vendedorID = 0;
  int articuloID = 0;
  double preciop = 0;
  String clienteName;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductoClienteController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: _.producto.length,
          itemBuilder: (context, index) {
            final ProductoCliente producto = _.producto[index];

            return Card(
              margin: EdgeInsets.all(
                15.0,
              ),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(
                    20.0,
                  ),
                  leading: Icon(Icons.crop_original, color: Colors.blue),
                  title: Text(producto.articulo),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      new Text('Precio \$: ' + producto.precio.toString(),
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      Divider(),
                      new Text('Existencia: ' + producto.existencia.toString(),
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent)),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          color: Colors.lightBlue,
                          onPressed: () {
                            _asyncInputDialog(context, producto.articuloId,
                                producto.precio, producto.existencia, _);
                          }),
                    ])
              ]),
            );
          },
        );
      },
    );
  }

  Future<String> _asyncInputDialog(BuildContext context, int idArticulo,
      double precio, double existencia, ProductoClienteController _) async {
    String teamName = '';
    String teamNames = "";

    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[100],
          title: Container(
            color: colorfondo,
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: Center(
              child: Text(
                'Cantidad a solicitar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Escriba la cantidad',
                  hintText: '0',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                onChanged: (value) {
                  teamName = value;
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Escriba la cantidad a cambiar',
                  hintText: '0',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                onChanged: (value) {
                  teamNames = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red[900],
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.green[900],
              child: Text('Aceptar'),
              onPressed: () async {
                if (existencia >= double.parse(teamName)) {
                  setState(() {
                    cantidad = double.parse(teamName);
                    cambio = teamNames != '' ? double.parse(teamNames) : 0;
                    preciop = precio;
                    articuloID = idArticulo;
                  });
                  int pedidoID = await ProductosClienteApi.instance
                      .addproduct(cantidad, articuloID, precio, cambio);
                  Navigator.of(context).pop();
                  if (pedidoID != 0) {
                    Toast.show(
                        "El producto fue agregado al pedido " +
                            pedidoID.toString(),
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.BOTTOM);
                  }
                } else {
                  _ackAlert(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Existencia'),
          content: const Text(
              'No hay existencia suficiente, para la cantidad solicitada'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
