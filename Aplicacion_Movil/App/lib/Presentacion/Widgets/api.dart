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
class Cliente {
  final int id;
  final String nombre;
  final String telefono;

  Cliente({required this.id, required this.nombre, required this.telefono});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      telefono: json['telefono'],
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

Future<List<Cliente>> obtenerClientes() async {
  final response = await http.get(
    Uri.parse('http://10.2.136.10:3000/clientes'),
  );

  if (response.statusCode == 200) {
    List data = json.decode(response.body);
    return data.map((e) => Cliente.fromJson(e)).toList();
  } else {
    throw Exception('Error al cargar clientes');
  }
}

Future<bool> guardarProveedor(
    String nombre,
    String telefono,
    String email,
    String direccion,
) async {
  final response = await http.post(
    Uri.parse('http://10.2.136.10:3000/proveedores'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "nombre": nombre,
      "telefono": telefono,
      "email": email,
      "direccion": direccion,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print(response.body);
    return false;
  }
}
class Movimiento {
  final int mes;
  final double total;

  Movimiento({required this.mes, required this.total});

  factory Movimiento.fromJson(Map<String, dynamic> json) {
    return Movimiento(
      mes: json['mes'],
      total: (json['total'] as num).toDouble(),
    );
  }
}

class InventarioService {
  static Future<List<Movimiento>> obtenerMovimientos() async { 
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/movimientos'),
    );

    final List data = json.decode(response.body);
    return data.map((e) => Movimiento.fromJson(e)).toList();
  }
}