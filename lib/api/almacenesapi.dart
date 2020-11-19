import 'dart:convert';

import 'package:dislacvta/models/almacenes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AlmacenesApi {
  AlmacenesApi._internal();

  static AlmacenesApi _instance = AlmacenesApi._internal();
  static AlmacenesApi get instance => _instance;

  //final _dio = Dio();

  Future<List<ModelAlmacenes>> getAlmacenes() async {
    SharedPreferences web = await SharedPreferences.getInstance();

    final response =
        await http.get(web.getString('WebApi') + '/api/GetAlmacenes');

    if (response.statusCode == 200) {
      List datauser = json.decode(response.body);
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return datauser.map((job) => new ModelAlmacenes.fromJson(job)).toList();
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }
}
