import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/nuevoproducto.dart';

class Gestionarproductos extends StatefulWidget {
  const Gestionarproductos({super.key});

  @override
  State<Gestionarproductos> createState() => _GestionarproductosState();
}

class _GestionarproductosState extends State<Gestionarproductos> {
  final String url = "http://10.2.127.40:5000/productos";

  Future<List<dynamic>> obtenerProductos() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar productos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const accentGreen = Color(0xFF054723);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: accentGreen,
        elevation: 0,
        title: const Text(
          "Inventario Nexus",
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}", 
              style: const TextStyle(color: Colors.white54))
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No hay productos registrados", 
              style: TextStyle(color: Colors.white54))
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final producto = snapshot.data![index];
              return Card(
                color: Colors.white.withOpacity(0.05),
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: accentGreen,
                    backgroundImage: producto['imagen'] != null && producto['imagen'].toString().isNotEmpty
                        ? NetworkImage(producto['imagen'])
                        : null,
                    child: producto['imagen'] == null || producto['imagen'].toString().isEmpty
                        ? const Icon(Icons.inventory, color: Colors.white)
                        : null,
                  ),
                  title: Text(
                    producto['nombre'] ?? "Sin nombre",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Stock: ${producto['cantidad']} | ${producto['estado']}",
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                  trailing: Text(
                    "\$${producto['precio']}",
                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          // Al volver de "Nuevo Producto", refrescamos la lista
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Nuevoproducto()),
          );
          setState(() {}); 
        },
        child: const Icon(Icons.add, color: Colors.greenAccent),
      ),
    );
  }
}