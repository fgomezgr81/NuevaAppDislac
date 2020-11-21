import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dislacvta/api/cortedeldia.dart';
import 'package:dislacvta/models/corte.dart';
import 'package:dislacvta/models/ventasclientes.dart';
import 'package:dislacvta/pages/ventas/detallecorte.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';

class PrintVentasDia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Dislac',
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    child: Text('Imprimir corte',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                      Get.to(DetalleCorte());
                    },
                    child: Text('Ver detalle corte',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
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

  void _tesPrint() async {
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
        Future<List<CorteDia>> _ventaDia;
        Future<List<VentaClientes>> _ventaDicClientes;

        _ventaDia = CorteApi.instance.ventaDia();

        _ventaDia.then((data) {
          String divisor = "";
          int p = 0;
          int i = 0;
          for (p = 0; p < 30; p++) {
            divisor += "_";
          }

          bluetooth.printNewLine();
          bluetooth.printLeftRight("", "DISLACVTA SA DE CV.", 0);
          bluetooth.printNewLine();
          bluetooth.printCustom(
              "             Calle Sinaloa 374, Las Mojoneras, 48290 Puerto Vallarta, Jal",
              0,
              0);
          bluetooth.printLeftRight("", "ventas@dislac.com.mx", 0);
          bluetooth.printLeftRight("", "Tel.: 322 290 1396", 0);
          bluetooth.printLeftRight("", "          322 290 2252 ", 0);
          bluetooth.printLeftRight("", "          FECHA CORTE ", 0);
          bluetooth.printLeftRight(
              "", DateTime.now().toString().substring(0, 19), 0);
          bluetooth.printCustom("                 " + divisor, 0, 0);
          bluetooth.printNewLine();
          bluetooth.printNewLine();

          for (i = 0; i < data.length; i++) {
            if (i == 0) {
              bluetooth.printLeftRight("        " + data[i].concepto,
                  "\$ " + data[i].total.toString(), 0);
            } else {
              bluetooth.printLeftRight("              " + data[i].concepto,
                  "\$ " + data[i].total.toString(), 0);
            }
            bluetooth.printNewLine();
          }
          if (data.length > 0) {
            bluetooth.printCustom(
                '                                      ', 0, 0);
            bluetooth.printCustom("               " + divisor, 0, 0);
            bluetooth.printNewLine();
            bluetooth.printNewLine();
            bluetooth.printNewLine();
            bluetooth.printNewLine();
          }
        });

        _ventaDicClientes = CorteApi.instance.ventaDiaCliente();
        _ventaDicClientes.then((valor) {
          int i = 0;
          for (i = 0; i < valor.length; i++) {
            String cliente = valor[i].cliente.substring(
                0, valor[i].cliente.length > 30 ? 30 : valor[i].cliente.length);

            if (cliente.length <= 30) {
              int p;
              for (p = cliente.length; p <= 32; p++) {
                cliente += " ";
              }
            }

            if (i == 0) {
              bluetooth.printLeftRight(
                  "        " + cliente, "\$ " + valor[i].importe.toString(), 0);
            } else {
              bluetooth.printLeftRight("                     " + cliente,
                  "\$ " + valor[i].importe.toString(), 0);
            }
          }
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printCustom('                                      ', 0, 0);
          bluetooth.paperCut();
        });
      }
    });
  }
}
