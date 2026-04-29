import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return {"status": "error", "message": "Por favor, complete todos los campos."};
    }

    final url = Uri.parse(ApiConfig.url('/login'));
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Error de conexión: $e"};
    }
  }

  Future<Map<String, dynamic>> registrar(String usuario, String email, String password) async {
    if (usuario.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      return {"status": "error", "message": "Todos los campos son obligatorios."};
    }

    final url = Uri.parse(ApiConfig.url('/registro'));
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": usuario,
          "email": email,
          "password": password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Error de conexión: $e"};
    }
  }
}