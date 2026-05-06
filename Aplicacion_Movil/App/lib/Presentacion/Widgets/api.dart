import 'dart:convert';
import 'package:http/http.dart' as http;

class Movimiento {
  final int mes;
  final double total;

  Movimiento({required this.mes, required this.total});

  factory Movimiento.fromJson(Map<String, dynamic> json) {
    return Movimiento(
      mes: json['mes'],
      total: double.parse(json['total'].toString()),
    );
  }
}

class InventarioService {
  static Future<List<Movimiento>> obtenerMovimientos() async {
    final response = await http.get(
      Uri.parse('http://10.2.139.243:3000/movimientos'),
    );
    print(response.body);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Movimiento.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar movimientos');
    }
  }
}
