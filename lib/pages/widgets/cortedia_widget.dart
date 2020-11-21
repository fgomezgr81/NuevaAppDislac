import 'package:dislacvta/controller/cortediacontroller.dart';
import 'package:dislacvta/models/corte.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CorteDiaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CorteDiaController>(
      builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_.corte.length > 0) {
          return ListView.builder(
            itemCount: _.corte.length,
            itemBuilder: (context, index) {
              final CorteDia corte = _.corte[index];

              return Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.crop_original, color: Colors.blue),
                    title: Text(corte.concepto),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        new Text('Total \$: ' + corte.total.toString(),
                            style: new TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Divider(),
                      ],
                    ),
                  ),
                ]),
              );
            },
          );
        } else {
          return Center(
            child: Text(
              'No existen movimientos para mostrar.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          );
        }
      },
    );
  }
}
