import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/NuevoCliente.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:file_picker/file_picker.dart'; 
import 'package:http/http.dart' as http;      

class Cliente extends StatelessWidget {
  const Cliente({super.key});

 Future<void> _importarDesdeCSV(BuildContext context) async {
  print("Abriendo selector de archivos..."); 
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result == null) {
      print("El usuario canceló la selección del archivo.");
      return;
    }

    print("Archivo seleccionado: ${result.files.single.name}");
    _mostrarNotificacion(context, "Enviando al servidor...", Colors.blue);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://10.198.83.247:5000/importar_clientes"),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'archivo',
        result.files.single.bytes!,
        filename: result.files.single.name,
      ),
    );

    print("Enviando petición a la IP: 10.198.83.247");
    var response = await request.send();

    print("Respuesta del servidor: ${response.statusCode}");

    if (response.statusCode == 201) {
      _mostrarNotificacion(context, "¡Importación exitosa! ✅", Colors.greenAccent);
    } else {
      _mostrarNotificacion(context, "Error servidor: ${response.statusCode}", Colors.redAccent);
    }
  } catch (e) {
    print("ERROR CRÍTICO: $e");
    _mostrarNotificacion(context, "Error: $e", Colors.orangeAccent);
  }
}

  void _mostrarNotificacion(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(color: Color(0xFF0D1B1E))),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: accentTeal.withOpacity(0.2),
        elevation: 0,
        title: const Text("CLIENTES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.sort, color: Colors.greenAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 170, height: 170,
              decoration: const BoxDecoration(color: Color(0xFF162A2D), shape: BoxShape.circle),
              child: const Icon(Icons.person_add_alt_1_rounded, size: 80, color: Colors.greenAccent),
            ),
            const SizedBox(height: 30),
            const Text("GESTIÓN DE CLIENTES", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, size: 30, color: primaryDark),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF162A2D),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuOption(
                      context,
                      icon: Icons.person_add_rounded,
                      label: "Nuevo Cliente",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Nuevocliente()));
                      },
                    ),
                    // Busca esta parte dentro del FloatingActionButton y reemplázala:
_buildMenuOption(
  context,
  icon: Icons.file_upload_outlined,
  label: "Importar Clientes",
  onTap: () async {
    print("Botón presionado: Iniciando selección de archivo..."); // ESTO DEBE SALIR EN LA CONSOLA DE FLUTTER
    Navigator.pop(context); // Cierra el menú
    await _importarDesdeCSV(context); // Ejecuta la importación
  },
),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.greenAccent),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}