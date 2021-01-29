import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...

*/

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  get cheque {
    return _prefs.getBool('cheque') ?? true;
  }

  set cheque(bool value) {
    _prefs.setBool('cheque', value);
  }

  get efectivo {
    return _prefs.getBool('efectivo') ?? true;
  }

  set efectivo(bool value) {
    _prefs.setBool('efectivo', value);
  }

  get credito {
    return _prefs.getBool('credito') ?? true;
  }

  set credito(bool value) {
    _prefs.setBool('credito', value);
  }

  get transferencia {
    return _prefs.getBool('transferencia') ?? true;
  }

  set transferencia(bool value) {
    _prefs.setBool('transferencia', value);
  }
}
