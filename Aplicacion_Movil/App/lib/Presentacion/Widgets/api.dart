import 'dart:convert';
import 'package:http/http.dart' as http;

class Producto {
  final int idProducto;
  final String nombre;
  final int stock;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.stock,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'],
      nombre: json['nombre'],
      stock: json['stock'],
    );
  }
}

Future<List<Producto>> fetchProductos() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:3000/productos'),
  );

  if (response.statusCode == 200) {
    List jsonData = jsonDecode(response.body);
    return jsonData.map((e) => Producto.fromJson(e)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
}
  
Future<bool> loginUsuario(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:3000/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  if (response.statusCode == 200) {
    return true; // Login correcto
  } else {
    return false; // Login incorrecto
  }
}