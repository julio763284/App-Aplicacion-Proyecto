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

  void _mostrarOpciones(BuildContext context, Map producto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blueAccent),
              title: const Text("Editar Producto", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text("Eliminar Producto", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
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
        title: const Text("Inventario Nexus", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 16)),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error de conexión", style: TextStyle(color: Colors.white54)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Sin productos", style: TextStyle(color: Colors.white54)));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              childAspectRatio: 0.20, 
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final producto = snapshot.data![index];
              return GestureDetector(
                onLongPress: () => _mostrarOpciones(context, producto),
                child: Card(
                  color: Colors.white.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      // SECCIÓN IMAGEN
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            image: DecorationImage(
                              image: producto['imagen'] != null && producto['imagen'].isNotEmpty
                                  ? NetworkImage(producto['imagen'])
                                  : const NetworkImage('https://via.placeholder.com/150'), // Imagen temporal
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      
                      // LA RAYITA BLANCA DIVISORA
                      const Divider(color: Colors.white24, height: 1, thickness: 1),

                      // SECCIÓN DESCRIPCIÓN
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto['nombre'] ?? "S/N",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Cant: ${producto['cantidad']}",
                                style: const TextStyle(color: Colors.white70, fontSize: 10),
                              ),
                              Text(
                                "\$${producto['precio']}",
                                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
          await Navigator.push(context, MaterialPageRoute(builder: (context) => Nuevoproducto()));
          setState(() {}); 
        },
        child: const Icon(Icons.add, color: Colors.greenAccent),
      ),
    );
  }
}