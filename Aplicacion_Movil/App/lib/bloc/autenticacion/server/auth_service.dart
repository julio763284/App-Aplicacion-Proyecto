import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';

class AuthService {
  // 1. Asegúrate que la IP sea la de tu PC (la que viste en el error)
  // 2. CAMBIA EL PUERTO A 5000
  final String baseUrl = "http://10.2.124.104:5000"; 

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

      final data = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          return {
            "status": "success",
            "message": "Inicio de sesión exitoso.",
            "data": data,
          };
        case 401:
          return {
            "status": "error",
            "message": "Contraseña incorrecta.",
          };
        case 404:
          return {
            "status": "error",
            "message": "Usuario no registrado.",
          };
        default:
          return {
            "status": "error",
            "message": data['message'] ?? "Ocurrió un error. Inténtalo más tarde.",
          };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Ocurrió un error. Inténtalo más tarde.",
      };
    }
  }

  Future<Map<String, dynamic>> registrar(String usuario, String email, String password) async {

  // Validación
  if (usuario.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
    return {"status": "error", "message": "Todos los campos son obligatorios."};
  }

  final url = Uri.parse('$baseUrl/registro');

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

    final data = jsonDecode(response.body);

    switch (response.statusCode) {
      case 201:
      case 200:
        return {
          "status": "success",
          "message": "Usuario registrado con éxito.",
        };

      case 409:
        return {
          "status": "error",
          "message": "El usuario o correo ya está registrado.",
        };

      default:
        return {
          "status": "error",
          "message": data['message'] ?? "Ocurrió un error. Inténtalo de nuevo.",
        };
    }
  } catch (e) {
    return {"status": "error", "message": "Error de conexión: $e"};
  }
}
}