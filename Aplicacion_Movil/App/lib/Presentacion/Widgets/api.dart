import 'dart:convert';
import 'package:http/http.dart' as http;

class Producto {
  final int id;
  final String nombre;
  final int cantidad;

  Producto({required this.id, required this.nombre, required this.cantidad});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
    );
  }
}

Future<List<Producto>> fetchProductos() async {
  final response = await http.get(Uri.parse('http://localhost:3000/productos'));

  if (response.statusCode == 200) {
    List jsonData = jsonDecode(response.body);
    return jsonData.map((e) => Producto.fromJson(e)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
}