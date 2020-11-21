import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dislacvta/models/modelprintdetalle.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_zsdk/flutter_zsdk.dart';

class PrintPedidoDetailPage extends StatefulWidget {
  @override
  _PrintPedidoDetailPageState createState() => _PrintPedidoDetailPageState();
}

class _PrintPedidoDetailPageState extends State<PrintPedidoDetailPage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getDetallePedido();
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
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imprimir pedido'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            padding: EdgeInsets.all(
              20.0,
            ),
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Impresora:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DropdownButton(
                      items: _getDeviceItems(),
                      onChanged: (value) => setState(() => _device = value),
                      value: _device,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.brown,
                    onPressed: () {
                      initPlatformState();
                    },
                    child: Text(
                      'Actualizar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: _connected ? Colors.red : Colors.green,
                    onPressed: _connected ? _disconnect : _connect,
                    child: Text(
                      _connected ? 'Desconectar' : 'Connectar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                child: RaisedButton(
                  color: Colors.brown,
                  onPressed: () {
                    //_printZPL(context);
                    _tesPrint();
                  },
                  child: Text('Imprimir pedido',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  Future<DetalleEncabezado> getDetallePedido() async {
    SharedPreferences pedidoID = await SharedPreferences.getInstance();

    final response = await http.get(pedidoID.getString('WebApi') +
        "/api/GetPedidoDetalle?DocumentoID=" +
        pedidoID.getInt('PedidoID').toString());

    if (response.statusCode == 200) {
      return DetalleEncabezado.fromJson(json.decode(response.body));
    }
    return null;
  }

  void _tesPrint() async {
    SharedPreferences pedidoID = await SharedPreferences.getInstance();
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        Future<DetalleEncabezado> detalle;

        detalle = getDetallePedido();
        detalle.then((data) {
          DetalleEncabezado encabezado = data;
          int p = 0;
          String nombre = encabezado.cliente.substring(0,
              encabezado.cliente.length > 32 ? 32 : encabezado.cliente.length);
          if (encabezado.cliente.length <= 32) {
            for (p = encabezado.cliente.length; p <= 32; p++) {
              nombre += " ";
            }
          }

          String divisor = "";

          for (p = 0; p < 30; p++) {
            divisor += "_";
          }
          print(nombre.length);

          bluetooth.printNewLine();
          bluetooth.printLeftRight("", "DISLACVTA SA DE CV.", 0);
          bluetooth.printNewLine();
          bluetooth.printCustom(
              "   Calle Sinaloa 374, Las Mojoneras, 48290 Puerto Vallarta, Jal",
              1,
              0);
          bluetooth.printLeftRight("", "ventas@dislac.com.mx", 1);
          bluetooth.printLeftRight("", "Tel.: 322 290 1396", 1);
          bluetooth.printLeftRight("", "          322 290 2252 ", 1);
          bluetooth.printCustom("              " + divisor, 0, 0);
          bluetooth.printLeftRight(
              "", "  Pedido: " + pedidoID.getInt("PedidoID").toString(), 1);
          // bluetooth.printLeftRight("",
          //     "            " + DateTime.now().toString().substring(0, 10), 0);
          bluetooth.printLeftRight("",
              "            " + encabezado.fecha.toString().substring(0, 10), 1);
          bluetooth.printCustom('                                      ', 1, 0);
          bluetooth.printCustom("                " + nombre, 1, 0);
          bluetooth.printCustom("       " + divisor, 1, 0);
          bluetooth.printNewLine();
          bluetooth.printNewLine();

          int i = 0;
          double articulot = 0;
          for (i = 0; i < encabezado.detallepedido.length; i++) {
            int p = 0;

            String descripcion = encabezado.detallepedido[i].articulo.substring(
                0,
                encabezado.detallepedido[i].articulo.length > 31
                    ? 31
                    : encabezado.detallepedido[i].articulo.length);
            if (encabezado.detallepedido[i].articulo.length <= 31) {
              for (p = encabezado.detallepedido[i].articulo.length;
                  p <= 31;
                  p++) {
                descripcion += " ";
              }
            }

            articulot += encabezado.detallepedido[i].unidades;
            //if (i == 0) {
            bluetooth.printNewLine();
            bluetooth.printCustom(
                ("         " + descripcion).substring(0, 40), 1, 2);
            bluetooth.printCustom(
                "         Cantidad    Precio   Sub-total ", 0, 0);
            bluetooth.printCustom(
                "        " +
                    encabezado.detallepedido[i].unidades.toString() +
                    "      \$" +
                    encabezado.detallepedido[i].precio.toString() +
                    "      \$" +
                    encabezado.detallepedido[i].importe.toString() +
                    "     ",
                0,
                0);
            bluetooth.printCustom('                                   ', 1, 0);
          }
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printCustom(
              "              Venta neta \$ " + encabezado.importe.toString(),
              0,
              2);
          bluetooth.printCustom('                                     ', 1, 0);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printNewLine();

          if (encabezado.formaPagoID == 71) {
            bluetooth.printCustom(
                "                    Debo(emos) y pagare(mos)  incondicionalmente a la orden de: Dislacvta, S.A de C.V. en  esta  ciudad  de  Puerto Vallarta, Jalisco,el dia " +
                    encabezado.fecha.toString() +
                    ".La cantidad de \$(" +
                    encabezado.importe.toString() +
                    " M.N.) Valor de la mercancia que he(emos) recibido a mi (nuestra) entera satisfaccion.",
                1,
                0);
            bluetooth.printNewLine();
            bluetooth.printCustom(
                "Este  pagare   es   mercantil  y  esta  regido por la Ley General de Titulos, en su articulo No.173 parte final  y  articulos correlativos  por ser pagare domiciliado. No pagandose a su vencimiento el importe de este pagare causara intereses a razon de2% mensual.",
                1,
                0);
            bluetooth.printCustom(
                '                                     ', 0, 0);
            bluetooth.printCustom(
                "                                          _______________________",
                0,
                0);
            bluetooth.printCustom("                          Firma", 1, 0);
            bluetooth.printCustom(
                '                                     ', 0, 0);
            bluetooth.printNewLine();
            bluetooth.printNewLine();
          }
          bluetooth.paperCut();
        });
      }
    });
  }

  _printZPL(context) async {
    Dialogs.show(context);
    SharedPreferences pedidoID = await SharedPreferences.getInstance();
    Future<DetalleEncabezado> detalle;

    detalle = getDetallePedido();
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
        ^FS ^FO50,500^FDPedido ${pedidoID.getInt("PedidoID")}
        ^FS ^FO50,540^GB700,1,3
        ^FS ^FX detalle del pedido 
        ^CFA,30 ''';

      int i = 0;

      for (i = 0; i < encabezado.detallepedido.length; i++) {
        zpl += ''' ^FO50,580^FD${encabezado.detallepedido[i].articulo}
        ^FS ^FO50,630
        ^FDCant.
        ^FS^FO290,630
        ^FDPrecio
        ^FS ^FO590,630
        ^FDImporte^FS 
         ^FO50,680
        ^FD${encabezado.detallepedido[i].unidades}^FS 
        ^FO290,680
        ^FD${encabezado.detallepedido[i].precio}
        ^FS ^FO590,680
        ^FD${encabezado.detallepedido[i].importe}^FS 
        ''';
      }

      zpl += '''  ^FX Importe total del pedido 
        ^CFA,30 
        ^FO300,750
        ^FDImporte
        ^FS ^FO600,750^FD${encabezado.importe}^FS 
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
