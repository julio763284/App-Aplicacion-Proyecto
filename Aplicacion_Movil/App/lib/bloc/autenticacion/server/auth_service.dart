import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // 1. Asegúrate que la IP sea la de tu PC (la que viste en el error)
  // 2. CAMBIA EL PUERTO A 5000
  final String baseUrl = "http://10.2.127.40:5000"; 

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
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
      return jsonDecode(response.body);
    } catch (e) {
      // ESTE ES EL MENSAJE QUE VES EN ROJO
      return {"status": "error", "message": "Error de conexión: $e"};
    }
  }
}