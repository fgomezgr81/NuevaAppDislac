import 'package:dio/dio.dart';
import 'package:dislacvta/pages/admin/homeadmin_page.dart';
import 'package:dislacvta/pages/traspasos/hometraspasos_page.dart';
import 'package:dislacvta/pages/ventas/homevtas_page.dart';
import 'package:dislacvta/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginApi {
  LoginApi._internal();

  static LoginApi _instance = LoginApi._internal();
  static LoginApi get instance => _instance;

  final _dio = Dio();

  getLogin(String user, String password, BuildContext context) async {
    Dialogs.show(context);

    Toast.show("Obtenemos las preferencias", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    SharedPreferences web = await SharedPreferences.getInstance();

    Toast.show("obtuvimos las preferencias", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    try {
      Toast.show("Obteenmos la respuesta del api", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      final Response response = await this
          ._dio
          .post(web.getString('WebApi') + "/api/GetUsuario", data: {
        "EmpleadoID": user,
        "Contraseña": password,
        "Emai": web.getString('deviceId')
      });

      Toast.show("Respuesta api", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      Dialogs.dismiss(context);

      if (response.data['success']) {
        web.setInt("VendedorID", int.parse(user));

        Toast.show("Tipo usuario " + response.data['TipoUsuarioID'].toString(),
            context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

        switch (response.data['TipoUsuarioID']) {
          case 1: //administrador
            Get.off(HomeAdminPage());
            break;
          case 2: //ventas
            Get.off(HomeVtasPage());
            break;
          case 3: // recepcion de mercancias
            print('Recepcion mercancias');
            break;
          default: //traspasos
            Get.off(HomeTrapasosPage());
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
