import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // IMPORTANTE: Agregamos http:// al inicio
  // Asegúrate que esta IP sea la que te da 'ipconfig' en la terminal
  final String baseUrl = "http://10.2.137.120:5000"; 

  Future<Map<String, dynamic>> login(String username, String password) async {
    // Verificamos que la URL se arme correctamente
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
      return {"status": "error", "message": "Error de conexión: $e"};
    }
  }
}