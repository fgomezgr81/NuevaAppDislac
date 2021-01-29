import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dislacvta/models/modelprintdetalle.dart';
import 'package:dislacvta/pages/ventas/homevtas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PrintPedidoPage extends StatefulWidget {
  @override
  _PrintPedidoPageState createState() => _PrintPedidoPageState();
}

class _PrintPedidoPageState extends State<PrintPedidoPage> {
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              padding: EdgeInsets.only(
                right: 10.0,
              ),
              icon: Icon(
                Icons.supervisor_account,
                size: 40,
              ),
              onPressed: () async {
                SharedPreferences config =
                    await SharedPreferences.getInstance();
                config.setInt('ClienteID', 0);
                config.setInt('PedidoID', 0);
                Get.off(HomeVtasPage());
              })
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
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
                height: 10,
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

          String _encabezado = "";
          _encabezado += "              DISLACVTA SA DE CV \n\n\r";
          _encabezado += "  Calle Sinaloa, Las Mojoneras\n\r";
          _encabezado += "C.P. 48290, Puerto Vallarta,Jal.\n\n\r";
          _encabezado += "       ventas@dislac.com.mx\n\n\r";
          _encabezado += "         Tel: 322 290 1396 \n\r";
          _encabezado += "              322 290 22522\n\r";
          _encabezado += "________________________________\n\n\r";
          _encabezado +=
              "         Folio:" + encabezado.folio.toString() + "\n\r";
          _encabezado += "       Fecha:" + encabezado.fecha + "\n\r";
          _encabezado += "________________________________\n\n\r";
          _encabezado += nombre + "\n\r";
          _encabezado += "________________________________\n\r\n\r";

          bluetooth.printCustom(_encabezado, 1, 1);

          int i = 0;
          double articulot = 0;
          for (i = 0; i < encabezado.detallepedido.length; i++) {
            int p = 0;
            String cuerpo = "";

            String descripcion = "       " +
                encabezado.detallepedido[i].articulo.substring(
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

            cuerpo += descripcion + "\n\r";
            cuerpo += "Cantidad     Precio    Sub-total\n\r";
            cuerpo += encabezado.detallepedido[i].unidades.toString() +
                "        \$" +
                encabezado.detallepedido[i].precio.toString() +
                "     \$" +
                encabezado.detallepedido[i].importe.toString() +
                "\n\r\n\r";

            bluetooth.printCustom(cuerpo, 1, 1);
          }
          String total = "\n\r\n\r            Venta neta \$" +
              encabezado.importe.toString() +
              "\n\r\n\r";
          bluetooth.printCustom(total, 1, 1);

          if (encabezado.formaPagoID == 71) {
            String pagare =
                "          Debo(emos) y pagare(mos)  incondicionalmente a la orden de: Dislacvta, S.A de C.V. en  esta  ciudad  de  Puerto Vallarta, Jalisco,el dia " +
                    encabezado.fecha.toString() +
                    ".La cantidad de \$(" +
                    encabezado.importe.toString() +
                    " M.N.) Valor de la mercancia que he(emos) recibido a mi (nuestra) entera satisfaccion.\n\r\n\r";
            pagare +=
                "Este  pagare   es   mercantil  y  esta  regido por la Ley General de Titulos, en su articulo No.173 parte final  y  articulos correlativos  por ser pagare domiciliado. No pagandose a su vencimiento el importe de este pagare causara intereses a razon de2% mensual.\n\r";
            pagare += "      _____________________\n\r\n\r";
            pagare += "            Firma\n\n\r";
            bluetooth.printCustom(pagare, 1, 1);
          }
          bluetooth.paperCut();
        });
      }
    });
  }
}
