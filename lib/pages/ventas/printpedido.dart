import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dislacvta/models/modelprintdetalle.dart';
import 'package:dislacvta/pages/ventas/homevtas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_zsdk/flutter_zsdk.dart';

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
              onPressed: () {
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
                    _printZPL();
                    //_tesPrint();
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
        String zpl = "";

        zpl += "^XA";
        zpl += "^FX Top section with logo, name and address.";
        zpl += "^CF0,60";
        zpl += "^FO120,50^FDDISLACVTA SA DE CV.^FS";
        zpl += "^CF0,30";
        zpl += "^FO120,115^FDCalle Sinaloa 374,Las Mojoneras,C.P. 48290^FS";
        zpl += "^FO220,155^FDPuerto Vallarta, Jal^FS";
        zpl += "^FO220,195^FDventas@dislac.com.mx^FS";
        zpl += "^FO220,235^FDTel.: 322 290 1396^FS";
        zpl += "^FO220,275^FDTel.: 322 290 2252^FS";
        zpl += "^FO50,315^GB700,1,3^FS";
        zpl +=
            "^FX Second section with recipient address and permit information.";
        zpl += "^CFA,30";
        zpl += "^FO50,340^FDJohn Doe^FS";
        zpl += "^FO50,380^FD100 Main Street^FS";
        zpl += "^FO50,420^FDSpringfield TN 39021^FS";
        zpl += "^FO50,460^FDUnited States (USA)^FS";
        zpl += "^FO50,500^FDPedido^FS";
        zpl += "^FO50,540^GB700,1,3^FS";
        zpl += "^FX detalle del pedido";
        zpl += "^CFA,30";
        zpl += "^FO50,580^FDDescripcion del producto se colocara aqui^FS";
        zpl += "^FO50,630^FDCant.^FS";
        zpl += "^FO290,630^FDPrecio^FS";
        zpl += "^FO590,630^FDImporte^FS";
        zpl += "^FO50,680^FD100^FS";
        zpl += "^FO290,680^FD10000^FS";
        zpl += "^FO590,680^FD10000^FS";
        zpl += "^FX Importe total del pedido";
        zpl += "^CFA,30";
        zpl += "^FO300,750^FDImporte^FS";
        zpl += "^FO600,750^FD10000^FS";
        zpl += "^XZ";
        bluetooth.printCustom(zpl, 3, 1);
        bluetooth.printNewLine();

        bluetooth.paperCut();
      }
    });
  }

  _printZPL() async {
    String zpl = "";

    zpl += "^XA";
    zpl += "^FX Top section with logo, name and address.";
    zpl += "^CF0,60";
    zpl += "^FO120,50^FDDISLACVTA SA DE CV.^FS";
    zpl += "^CF0,30";
    zpl += "^FO120,115^FDCalle Sinaloa 374,Las Mojoneras,C.P. 48290^FS";
    zpl += "^FO220,155^FDPuerto Vallarta, Jal^FS";
    zpl += "^FO220,195^FDventas@dislac.com.mx^FS";
    zpl += "^FO220,235^FDTel.: 322 290 1396^FS";
    zpl += "^FO220,275^FDTel.: 322 290 2252^FS";
    zpl += "^FO50,315^GB700,1,3^FS";
    zpl += "^FX Second section with recipient address and permit information.";
    zpl += "^CFA,30";
    zpl += "^FO50,340^FDJohn Doe^FS";
    zpl += "^FO50,380^FD100 Main Street^FS";
    zpl += "^FO50,420^FDSpringfield TN 39021^FS";
    zpl += "^FO50,460^FDUnited States (USA)^FS";
    zpl += "^FO50,500^FDPedido^FS";
    zpl += "^FO50,540^GB700,1,3^FS";
    zpl += "^FX detalle del pedido";
    zpl += "^CFA,30";
    zpl += "^FO50,580^FDDescripcion del producto se colocara aqui^FS";
    zpl += "^FO50,630^FDCant.^FS";
    zpl += "^FO290,630^FDPrecio^FS";
    zpl += "^FO590,630^FDImporte^FS";
    zpl += "^FO50,680^FD100^FS";
    zpl += "^FO290,680^FD10000^FS";
    zpl += "^FO590,680^FD10000^FS";
    zpl += "^FX Importe total del pedido";
    zpl += "^CFA,30";
    zpl += "^FO300,750^FDImporte^FS";
    zpl += "^FO600,750^FD10000^FS";
    zpl += "^XZ";

    List<ZebraBluetoothDevice> devices =
        await FlutterZsdk.discoverBluetoothDevices();
    print("Found ${devices.length} BL device(s)");
    devices.forEach((ZebraBluetoothDevice printer) {
      if (printer.friendlyName.toLowerCase().contains("meza")) {
        print("Running print");
        printer.sendZplOverBluetooth(zpl);
      }
    });
  }
}
