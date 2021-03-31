import 'package:dislacvta/pages/home_page.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _grabarconfiguracion();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(
        Duration(
          seconds: 3,
        ), () {
      Get.off(
        HomePage(),
        transition: Transition.leftToRight,
      );
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  _grabarconfiguracion() async {
    SharedPreferences configuracion = await SharedPreferences.getInstance();

    // await configuracion.setString("WebApi", "http://dislacvta.dyndns.org/Web");
    await configuracion.setString("WebApi", "http://192.168.0.7/WebApi");
  }
}
