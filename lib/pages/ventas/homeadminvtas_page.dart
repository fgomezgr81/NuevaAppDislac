import 'package:dislacvta/pages/admin/homeadmin_page.dart';
import 'package:dislacvta/pages/ventas/clientesvtas_page.dart';
import 'package:dislacvta/pages/ventas/pedidos_page.dart';
import 'package:dislacvta/pages/ventas/pedidoscredito_page.dart';
import 'package:dislacvta/pages/ventas/pedidoshistorico_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomeAdminVtasPage extends StatelessWidget {
  const HomeAdminVtasPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = new DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(0, 200, 228, 10),
            title: Text(
              "Dislac Vta",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 30,
                  ),
                  onPressed: () {
                    Get.to(HomeAdminPage());
                  })
            ],
            bottom: TabBar(indicatorColor: Colors.red, tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.add_shopping_cart,
                  size: 30,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.monetization_on,
                  size: 30,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.access_alarms,
                  size: 30,
                ),
              ),
            ]),
          ),
          body: TabBarView(children: <Widget>[
            ClientesVtasPage(),
            PedidosPage(),
            PedidosCreditoPage(),
            PedidosHistoricoPage(),
          ]),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: tabController,
      ),
    );
  }
}
