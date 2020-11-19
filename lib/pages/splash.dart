import 'dart:ui';

import 'package:dislacvta/controller/splashcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (_) => Scaffold(
        body: Center(
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * .22,
                left: MediaQuery.of(context).size.width * .17,
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .6,
                left: MediaQuery.of(context).size.width * .30,
                child: Image.asset(
                  'assets/cargando.gif',
                  width: 150,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
