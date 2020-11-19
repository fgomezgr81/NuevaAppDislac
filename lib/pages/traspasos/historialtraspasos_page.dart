import 'package:dislacvta/controller/hitorialtraspasoscontroller.dart';
import 'package:dislacvta/pages/traspasos/widgets/historialtraspasos_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController editingController;

class HistorialTrapasosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistorialTraspasosController>(
      init: HistorialTraspasosController(),
      builder: (_) {
        return Scaffold(
          body: Container(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: editingController,
                  onChanged: (value) {
                    _.loadSearchHistorialTraspasos(int.parse(value));
                  },
                  decoration: InputDecoration(
                      labelText: "Escriba el numero de trapaso",
                      hintText: "Escriba el numero de trapaso",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
                child: HistorialTrapasosWidget(),
              ),
            ],
          )),
        );
      },
    );
  }
}
