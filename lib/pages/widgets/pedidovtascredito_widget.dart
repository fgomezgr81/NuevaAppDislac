import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dislacvta/api/pedidosvtasapi.dart';
import 'package:dislacvta/controller/pedidoscreditocontroller.dart';
import 'package:dislacvta/models/modelprintdetalle.dart';
import 'package:dislacvta/models/pedidosvtas.dart';
import 'package:dislacvta/pages/ventas/detallepedido.dart';
import 'package:dislacvta/pages/ventas/printpedidoDetail.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zsdk/flutter_zsdk.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedidosCreditoVtasWidget extends StatefulWidget {
  @override
  _PedidosCreditoVtasWidgetState createState() =>
      _PedidosCreditoVtasWidgetState();
}

class _PedidosCreditoVtasWidgetState extends State<PedidosCreditoVtasWidget> {
  //List<ZebraBluetoothDevice> _devices = List();
  BluetoothDevice _device;
  bool _connected = false;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      //_devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PedidosCreditoVtasController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: _.pedidos.length,
          itemBuilder: (context, index) {
            final ModelPedido pedidos = _.pedidos[index];
            return Card(
              margin: EdgeInsets.all(15.0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(
                    10.0,
                  ),
                  leading: Icon(Icons.add_shopping_cart, color: Colors.blue),
                  title: Text(pedidos.nombre),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      new Text('Importe \$: ' + pedidos.importe.toString(),
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      Divider(),
                      Text(
                          'Fecha : ' +
                              pedidos.fecha.toString().substring(
                                  0, pedidos.fecha.toString().length - 12),
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      Divider(),
                      Text('Forma de cobro:' + pedidos.formaCobro,
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      Divider()
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          color: Colors.amber,
                          onPressed: () {
                            //guardamos el pedido
                            _grabarpreferences(pedidos.idDocumento);

                            Get.to(DetallePedido());
                          }),
                      IconButton(
                          icon: Icon(Icons.print),
                          color: Colors.lightBlue,
                          onPressed: () {
                            //guardamos el pedido
                            // _grabarpreferences(pedidos.idDocumento);

                            // Get.to(PrintPedidoDetailPage());
                            _printTikect(pedidos.idDocumento, context);
                          }),
                      IconButton(
                          icon: pedidos.pagoid == 71
                              ? pedidos.formapagoid == 0
                                  ? Icon(Icons.credit_card)
                                  : Icon(Icons.check)
                              : Icon(Icons.check),
                          color: pedidos.pagoid == 71
                              ? pedidos.formapagoid == 0
                                  ? Colors.redAccent
                                  : Colors.grey
                              : Colors.grey,
                          onPressed: () {
                            if (pedidos.pagoid == 71) {
                              _asyncSimpleDialog(context, pedidos.idDocumento);
                            } else {
                              // _pagado(context);
                            }
                          })
                    ])
              ]),
            );
          },
        );
      },
    );
  }

  _grabarpreferences(int pedidoID) async {
    SharedPreferences vendedor = await SharedPreferences.getInstance();
    await vendedor.setInt("PedidoID", pedidoID);
  }

  Future<void> _asyncSimpleDialog(BuildContext context, int pedidoID) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Seleccione una opcion'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  _getBanco(context, 68, pedidoID);
                  //Navigator.of(context).pop();
                },
                child: const Text('Cheque'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  PedidosvtaApi.instance.pagarPedido(67, pedidoID, '', '');
                  Navigator.of(context).pop();
                },
                child: const Text('Efectivo'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  _getBanco(context, 9660, pedidoID);
                  //Navigator.of(context).pop();
                },
                child: const Text('Transferencia'),
              ),
            ],
          );
        });
  }

  Future<String> _getBanco(BuildContext context, int tipo, int pedidoID) async {
    String teamName = '';
    String referencia = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Banco'),
          content:
              new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            TextField(
              decoration:
                  InputDecoration(labelText: 'Banco', hintText: 'Bancomer'),
              onChanged: (value) {
                teamName = value;
              },
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Referencia', hintText: '001289'),
              onChanged: (value) {
                referencia = value;
              },
            )
          ]),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                PedidosvtaApi.instance
                    .pagarPedido(tipo, pedidoID, teamName, referencia);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _printTikect(int pedidoID, BuildContext context) async {
    Dialogs.printer(context);
    Future<DetalleEncabezado> detalle;

    detalle = PedidosvtaApi.instance.getDetallePedido(pedidoID);
    detalle.then((data) async {
      DetalleEncabezado encabezado = data;
      int p = 0;
      String nombre = encabezado.cliente.substring(
          0, encabezado.cliente.length > 32 ? 32 : encabezado.cliente.length);
      if (encabezado.cliente.length <= 32) {
        for (p = encabezado.cliente.length; p <= 32; p++) {
          nombre += " ";
        }
      }

      String zpl;
      zpl = '''^XA 
        ^CF0,60 
        ^FO120,50^FDDISLACVTA SA DE CV.
        ^FS ^CF0,30 
        ^FO120,115^FDCalle Sinaloa 374,Las Mojoneras,C.P. 48290
        ^FS ^FO220,155^FDPuerto Vallarta, Jal
        ^FS ^FO220,195^FDventas@dislac.com.mx
        ^FS ^FO220,235^FDTel.: 322 290 1396
        ^FS ^FO220,275^FDTel.: 322 290 2252
        ^FS ^FO50,315^GB700,1,3
        ^FS ^FX Second section with recipient address and permit information. 
        ^CFA,30 ^FO50,340^FD${nombre}
        ^FS ^FO50,500^FDPedido ${pedidoID}
        ^FS ^FO50,540^GB700,1,3
        ^FS ^FX detalle del pedido 
        ^CFA,30 ''';

      int i = 0;
      int linea = 630, lineaprecio = 680;

      for (i = 0; i < encabezado.detallepedido.length; i++) {
        zpl += ''' ^FO50,580^FD${encabezado.detallepedido[i].articulo}
        ^FS ^FO50,${linea}
        ^FDCant.
        ^FS^FO290,${linea}
        ^FDPrecio
        ^FS ^FO590,${linea}
        ^FDImporte^FS 
         ^FO50,${lineaprecio}
        ^FD${encabezado.detallepedido[i].unidades}^FS 
        ^FO290,${lineaprecio}
        ^FD${encabezado.detallepedido[i].precio}
        ^FS ^FO590,${lineaprecio}
        ^FD${encabezado.detallepedido[i].importe}^FS 
        ''';
        linea += 50;
        lineaprecio += 50;
      }

      zpl += '''  ^FX Importe total del pedido 
        ^CFA,30 
        ^FO300,${linea}
        ^FDImporte
        ^FS ^FO600,${linea}
        ^FD${encabezado.importe}^FS 
        ^XZ''';

      List<ZebraBluetoothDevice> devices =
          await FlutterZsdk.discoverBluetoothDevices();
      print("Found ${devices.length} BL device(s)");
      devices.forEach((ZebraBluetoothDevice printer) {
        if (printer.friendlyName.toLowerCase().contains("meza")) {
          print("Running print");
          printer.sendZplOverBluetooth(zpl).then((t) {
            print("Printing complete");
          });
        }
      });

      Dialogs.dismiss(context);
    });
  }
}
