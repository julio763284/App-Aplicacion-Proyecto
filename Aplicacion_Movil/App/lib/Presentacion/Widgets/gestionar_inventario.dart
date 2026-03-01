import 'package:flutter/material.dart';

class GestionarInventarioPage extends StatefulWidget {
  @override
  _GestionarInventarioPageState createState() =>
      _GestionarInventarioPageState();
}

class _GestionarInventarioPageState extends State<GestionarInventarioPage> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> inventariosUsuario = [];
  List<Map<String, dynamic>> inventariosFiltrados = [];

  @override
  void initState() {
    super.initState();
    cargarInventarios(); // Aquí cargarás los datos reales
  }

  // 🔹 MÉTODO PARA CARGAR INVENTARIOS REALES
  Future<void> cargarInventarios() async {
    // TODO: Reemplazar con llamada real (Firebase, API, SQLite, etc)

    List<Map<String, dynamic>> datosReales = await obtenerInventarios();

    setState(() {
      inventariosUsuario = datosReales;
      inventariosFiltrados = datosReales;
    });
  }

  // 🔹 SIMULACIÓN (ELIMÍNALA CUANDO CONECTES TU BACKEND)
  Future<List<Map<String, dynamic>>> obtenerInventarios() async {
    await Future.delayed(Duration(seconds: 1));

    return []; // ← Aquí vendrán tus inventarios reales
  }

  void filtrarInventarios(String query) {
    final resultados = inventariosUsuario.where((inventario) {
      final nombre = inventario["nombre"]
          .toString()
          .toLowerCase();
      return nombre.contains(query.toLowerCase());
    }).toList();

    setState(() {
      inventariosFiltrados = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Inventarios"),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: () {
          // Navegar a crear inventario
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: filtrarInventarios,
              decoration: InputDecoration(
                hintText: "Buscar inventario...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: inventariosFiltrados.isEmpty
                ? Center(
                    child: Text(
                      "No tienes inventarios registrados",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: inventariosFiltrados.length,
                    itemBuilder: (context, index) {
                      final inventario = inventariosFiltrados[index];

                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.inventory,
                                color: Colors.white),
                          ),
                          title: Text(
                            inventario["nombre"] ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "${inventario["productos"] ?? 0} productos"),
                          trailing:
                              Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            // Abrir inventario seleccionado
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}