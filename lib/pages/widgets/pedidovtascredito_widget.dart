//import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dislacvta/api/pedidosvtasapi.dart';
import 'package:dislacvta/controller/pedidoscreditocontroller.dart';
import 'package:dislacvta/models/modelprintdetalle.dart';
import 'package:dislacvta/models/pedidosvtas.dart';
import 'package:dislacvta/pages/ventas/detallepedido.dart';
import 'package:dislacvta/pages/ventas/printpedidoDetail.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedidosCreditoVtasWidget extends StatefulWidget {
  @override
  _PedidosCreditoVtasWidgetState createState() =>
      _PedidosCreditoVtasWidgetState();
}

class _PedidosCreditoVtasWidgetState extends State<PedidosCreditoVtasWidget> {
  //List<ZebraBluetoothDevice> _devices = List();

  @override
  void initState() {
    super.initState();
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
                            _grabarpreferences(pedidos.idDocumento);

                            Get.to(PrintPedidoDetailPage());
                            // _printTikect(pedidos.idDocumento, context);
                            //_printTikectzpl(pedidos.idDocumento, context);
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
      // zpl = '''^XA
      //   ^CF0,60
      //   ^FO120,50^FDDISLACVTA SA DE CV.
      //   ^FS ^CF0,30
      //   ^FO120,115^FDCalle Sinaloa 374,Las Mojoneras,C.P. 48290
      //   ^FS ^FO220,155^FDPuerto Vallarta, Jal
      //   ^FS ^FO220,195^FDventas@dislac.com.mx
      //   ^FS ^FO220,235^FDTel.: 322 290 1396
      //   ^FS ^FO220,275^FDTel.: 322 290 2252
      //   ^FS ^FO50,315^GB700,1,3
      //   ^FS ^FX Second section with recipient address and permit information.
      //   ^CFA,30 ^FO50,340^FD${nombre}
      //   ^FS ^FO50,500^FDPedido ${pedidoID}
      //   ^FS ^FO50,540^GB700,1,3
      //   ^FS ^FX detalle del pedido
      //   ^CFA,30 ^XZ''';
      zpl = '''^XA^MNN^LL900^XZ^XA^JUS^XZ
						^XA
						^FO50,50^GFA,1586,1586,13,,:::::R0F,Q03FC,Q0IF,P03IFC,P0KF,O03KFC,O0MF,N03MFC,N0OF,M03OFC,M0QF,L03QFC,L0SF,K03SFC,K0UF,J03UFC,J0WF,I03NF0NFC,I0NFC03NF,003NFI0NFC,00NFCI03NF,03NFK0NFC,03MFCJ01NF8,03MFK07MFE,03LFCJ01NF8,03LFK07MFE,03KFCJ01NF8,01KFK07MFE,01JFCJ01NF8,01JFK07MFE,01IFCJ01NF8,01IFK07MFE,01FFCJ01NF8,00FFK07MFE,00FCJ01NF8J03,00FK07MFEK0F,00CJ01NF8J03F,M07MFEK0FF,L01NF8J03FF,L07MFEK0FFE,K01NF8J03FFE,K07MFEK0IFE,J01NF8J03IFE,J07MFEK0JFE,I01NF8J03JFE,I07MFEK0KFC,001NF8J03KFC,003MFEK0LFC,003MF8J03LFC,003LFEK0MFC,003LF8J03MFC,001KFEK0NF8,001KF8J03NF8,001JFEK0OF8,001JF8J03OF8,001IFEK0PF8,001IF8J01PF8,I0IF8K0PF,::I0IF8K0LFBIF,I0IFCK0KFE3IF,I0IFCK0KF83IF,I07FFCK0JFE03FFE,I07FFCK07IF803FFE,I07FFCK07FFE003FFE,I07FFCK07FF8007FFE,I07FFEK07FEI07FFE,I07FFEK07F8I07FFE,I03FFEK07EJ07FFC,I03FFEK038J07FFC,I03FFEK02K07FFC,I03FFEQ0IFC,I03IFQ0IFC,:I01IFQ0IF8,:I01IFCO03IF8,I01IFEO07IF8,I01JF8M01JF8,I01JFCM03JF8,J0KFM0KF,J0KF8K01KF,J0KFEK07KF,J0LFK0LF,J0LFCI03LF,J0LFEI07LF,J07LF801LFE,J07LFC03LFE,J01MF0MF8,K0MF9MF,K03SFC,K01SF8,L07QFE,L03QFC,M0QF,M07OFE,M01OF8,N0OF,N03MFC,N01MF8,O07KFE,O03KFC,P0KF,P07IFE,P01IF8,Q0IF,Q03FC,Q01F8,R06,,:::::^FS
						^FX 
						^CF0,30
						^FO170,60^FDesteregistro['nombreCia']^FS
						^CF0,20
						^FO170,100^FDR.T.N: esteregistro['ciartn']^FS
						^FO170,130^FDTel: esteregistro['telefono']^FS
						^FO170,160^FDCorreo: esteregistro['correo']^FS
						^FO5,210^GB700,1,3^FS
						^FX 
						^CFA,15
						^FO5,240^FDesteregistro['ciashort']^FS
						^FO5,260^FDDireccion: esteregistro['ciadir']^FS
						^FO5,300^FDC.A.I: esteregistro['cai']^FS
						^FO5,320^FDFECHA LIMITE DE EMISION: esteregistro['limite']^FS
						^FO5,360^FDFECHA: esteregistro['fecha']^FS
						^FO5,380^FDFACTURA No. esteregistro['factura_seriefiscal']^FS
						^FO5,400^FDCONTADO^FS
						^FO5,440^FDCLIENTE: esteregistro['cli_nid']^FS
						^FO5,460^FDNOMBRE: esteregistro['cli_vnombre']^FS
						^FO5,480^FDR.T.N: esteregistro['cli_vrtn']^FS
						^FO5,520^GB700,1,3^FS
						^FX 
						^FO5,540^FDDETALLE:^FS
						^FO5,570^FDCANT^FS
						^FO80,570^FDDESCRIPCION^FS
						^FO365,570^FDDESC^FS
						^FO435,570^FDP/U^FS
						^FO520,570^FDTOTAL^FS
						^FX 
						^CFA,15
						^XZ''';

      // int i = 0;
      // int linea = 630, lineaprecio = 680;

      // for (i = 0; i < encabezado.detallepedido.length; i++) {
      //   zpl += ''' ^FO50,580^FD${encabezado.detallepedido[i].articulo}
      //   ^FS ^FO50,${linea}
      //   ^FDCant.
      //   ^FS^FO290,${linea}
      //   ^FDPrecio
      //   ^FS ^FO590,${linea}
      //   ^FDImporte^FS
      //    ^FO50,${lineaprecio}
      //   ^FD${encabezado.detallepedido[i].unidades}^FS
      //   ^FO290,${lineaprecio}
      //   ^FD${encabezado.detallepedido[i].precio}
      //   ^FS ^FO590,${lineaprecio}
      //   ^FD${encabezado.detallepedido[i].importe}^FS
      //   ''';
      //   linea += 50;
      //   lineaprecio += 50;
      // }

      // zpl += '''  ^FX Importe total del pedido
      //   ^CFA,30
      //   ^FO300,${linea}
      //   ^FDImporte
      //   ^FS ^FO600,${linea}
      //   ^FD${encabezado.importe}^FS
      //   ^XZ''';

      // zpl =
      //   "^XA^FX Second section with recipient address and permit information.^CFA,20^FO50,100^FDJohn Doe^FS^FO50,140^FD100 Main Street^FS^FO50,180^FDSpringfield TN 39021^FS^FO50,220^FDUnited States (USA)^FS^XZ";

      // List<ZebraBluetoothDevice> devices =
      //     await FlutterZsdk.discoverBluetoothDevices();
      // print("Found ${devices.length} BL device(s)");

      // devices.forEach((ZebraBluetoothDevice printer) {
      //   if (printer.friendlyName.toLowerCase().contains("meza")) {
      //     print("Running print");
      //     print(zpl.toString());
      //     printer.sendZplOverBluetooth(zpl.toString()).then((t) {
      //       print("Printing complete");
      //     });
      //   }
      // });

      Dialogs.dismiss(context);
    });
  }

  // _printTikectzpl(int pedidoID, BuildContext context) async {
  //   Dialogs.printer(context);
  //   Future<DetalleEncabezado> detalle;

  //   detalle = PedidosvtaApi.instance.getDetallePedido(pedidoID);
  //   detalle.then((data) async {
  //     DetalleEncabezado encabezado = data;
  //     int p = 0;
  //     String nombre = encabezado.cliente.substring(
  //         0, encabezado.cliente.length > 32 ? 32 : encabezado.cliente.length);
  //     if (encabezado.cliente.length <= 32) {
  //       for (p = encabezado.cliente.length; p <= 32; p++) {
  //         nombre += " ";
  //       }
  //     }

  //     String zpl;
  //     zpl = '''^XA
  //       ^CF0,60
  //       ^FO120,50^FDDISLACVTA SA DE CV.
  //       ^FS ^CF0,30
  //       ^FO120,115^FDCalle Sinaloa 374,Las Mojoneras,C.P. 48290
  //       ^FS ^FO220,155^FDPuerto Vallarta, Jal
  //       ^FS ^FO220,195^FDventas@dislac.com.mx
  //       ^FS ^FO220,235^FDTel.: 322 290 1396
  //       ^FS ^FO220,275^FDTel.: 322 290 2252
  //       ^FS ^FO50,315^GB700,1,3
  //       ^FS ^FX Second section with recipient address and permit information.
  //       ^CFA,30 ^FO50,340^FD${nombre}
  //       ^FS ^FO50,500^FDPedido ${pedidoID}
  //       ^FS ^FO50,540^GB700,1,3
  //       ^FS ^FX detalle del pedido
  //       ^CFA,30 ''';

  //     int i = 0;
  //     int linea = 630, lineaprecio = 680;

  //     for (i = 0; i < encabezado.detallepedido.length; i++) {
  //       zpl += ''' ^FO50,580^FD${encabezado.detallepedido[i].articulo}
  //       ^FS ^FO50,${linea}
  //       ^FDCant.
  //       ^FS^FO290,${linea}
  //       ^FDPrecio
  //       ^FS ^FO590,${linea}
  //       ^FDImporte^FS
  //        ^FO50,${lineaprecio}
  //       ^FD${encabezado.detallepedido[i].unidades}^FS
  //       ^FO290,${lineaprecio}
  //       ^FD${encabezado.detallepedido[i].precio}
  //       ^FS ^FO590,${lineaprecio}
  //       ^FD${encabezado.detallepedido[i].importe}^FS
  //       ''';
  //       linea += 50;
  //       lineaprecio += 50;
  //     }

  //     zpl += '''  ^FX Importe total del pedido
  //       ^CFA,30
  //       ^FO300,${linea}
  //       ^FDImporte
  //       ^FS ^FO600,${linea}
  //       ^FD${encabezado.importe}^FS
  //       ^XZ''';

  //     try {
  //       BluetoothConnection connection;
  //       String mac = "0C:A6:94:D8:99:4E";
  //       await BluetoothConnection.toAddress(mac).then((_connection) {
  //         connection = _connection;
  //       });

  //       print("Running print");

  //       print(zpl);
  //       connection.output.add(utf8.encode(zpl));
  //       connection.finish();

  //       print("Complete");
  //     } catch (exception) {
  //       print(
  //           'Cannot connect, exception occured, message:${exception.toString()}');
  //     }

  //     Dialogs.dismiss(context);
  //   });
  // }
}
