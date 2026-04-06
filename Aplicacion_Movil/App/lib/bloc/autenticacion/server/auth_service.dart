import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String urlBase = "http://10.0.2.2:3000"; 

  Future<bool> validarLogin(String correo, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$urlBase/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'password': password}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}