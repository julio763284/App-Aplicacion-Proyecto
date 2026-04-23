import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // 10.0.2.2 es para el emulador de Android. 
  // Si usas el navegador (Web), cambia a 'localhost'.
  final String baseUrl = "http://10.2.125.207:5000"; 

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "No se pudo conectar al servidor"};
    }
  }
}