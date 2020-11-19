import 'package:dislacvta/pages/login_page.dart';
import 'package:dislacvta/pages/traspasos/hometraspasosadmin_page.dart';
import 'package:dislacvta/pages/ventas/homeadminvtas_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomeAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(0, 200, 228, 10),
          title: Text(
            "Administrador",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  size: 40,
                ),
                onPressed: () {
                  Get.to(LoginPage());
                })
          ],
        ),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Get.to(HomeAdminVtasPage());
                },
                child: Center(
                  child: Text(
                    'Ventas',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.teal[100],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: ExactAssetImage(
                    'assets/ventas.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Get.to(HomeAdminTrapasosPage());
                },
                child: Center(
                  child: Text(
                    'Trapasos',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.teal[100],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: ExactAssetImage(
                    'assets/traspasos.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ));
  }
}
