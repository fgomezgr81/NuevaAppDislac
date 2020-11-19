import 'package:dislacvta/pages/admin/homeadmin_page.dart';
import 'package:dislacvta/pages/traspasos/historialtraspasos_page.dart';
import 'package:dislacvta/pages/traspasos/traspasos_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomeAdminTrapasosPage extends StatelessWidget {
  const HomeAdminTrapasosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = new DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(0, 200, 228, 10),
            title: Text(
              "Dislac Vta (Traspasos)",
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
                  Icons.wifi_protected_setup,
                  size: 30,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.add_chart,
                  size: 30,
                ),
              ),
            ]),
          ),
          body: TabBarView(children: <Widget>[
            TrapasosPage(),
            HistorialTrapasosPage(),
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
