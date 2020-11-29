import 'package:dio/dio.dart';
import 'package:dislacvta/pages/admin/homeadmin_page.dart';
import 'package:dislacvta/pages/inventarios/homeinvetarios.dart';
import 'package:dislacvta/pages/orcenescompra/homeordenescompra.dart';
import 'package:dislacvta/pages/traspasos/hometraspasos_page.dart';
import 'package:dislacvta/pages/ventas/homevtas_page.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  LoginApi._internal();

  static LoginApi _instance = LoginApi._internal();
  static LoginApi get instance => _instance;

  final _dio = Dio();

  getLogin(String user, String password, BuildContext context) async {
    Dialogs.show(context);

    SharedPreferences web = await SharedPreferences.getInstance();

    try {
      final Response response = await this
          ._dio
          .post(web.getString('WebApi') + "/api/GetUsuario", data: {
        "EmpleadoID": user,
        "Contraseña": password,
        "Emai": web.getString('deviceId')
      });

      Dialogs.dismiss(context);

      if (response.data['success']) {
        web.setInt("VendedorID", int.parse(user));

        switch (response.data['TipoUsuarioID']) {
          case 1: //administrador
            Get.off(HomeAdminPage());
            break;
          case 2: //ventas
            Get.off(HomeVtasPage());
            break;
          case 3: // recepcion de mercancias
            Get.off(OrdenesCompraPage());
            break;
          case 4: //traspasos
            Get.off(HomeTrapasosPage());
            break;
          case 5: //Inventarios
            Get.off(HomeInventarios());
            break;
          default:
            Dialogs.popupDialog(
                context, "Login", "No existe el tipo de usuario.");
            break;
        }
      } else {
        Dialogs.popupDialog(
            context, "Login", "Usuario y/o contraseña incorrectos.");
      }
    } catch (e) {
      print(e);
    }
  }
}
