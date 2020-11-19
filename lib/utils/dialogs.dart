import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constantes.dart';

abstract class Dialogs {
  static show(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Center(
              child: Image.asset(
                'assets/cargando.gif',
                width: 100,
              ),
            ),
          ),
        );
      },
    );
  }

  static printer(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Center(
              child: Image.asset(
                'assets/printer.gif',
                width: 100,
              ),
            ),
          ),
        );
      },
    );
  }

  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  static popupDialog(BuildContext context, String titulo, String message) {
    showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
              color: Colors.red[600],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .05,
              child: Center(
                child: Text(
                  titulo,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            content: Text(
              message,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  static alertCredito(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorbase,
          title: Container(
            color: Colors.amber[100],
            height: 50,
            child: Center(
              child: Text(
                'Advertencia',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          content: const Text(
            'El cliente excedio su limite de credito, por lo cual no se le puede vender.',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red[900],
              child: const Text('Aceptar'),
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
