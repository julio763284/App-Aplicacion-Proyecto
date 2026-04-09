import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Nuevoproveedor extends StatelessWidget {
  Nuevoproveedor({super.key});
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();

  static const Color colorPrincipal = Color.fromARGB(255, 1, 122, 116);

  final String url = "http://10.2.139.243:3000/proveedores"; 

  Future<void> guardarCliente(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombreController.text,
          "telefono": direccionController.text,
          "email": correoController.text,
          "direccion": telefonoController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proveedor guardado correctamente ✅')),
        );

        nombreController.clear();
        direccionController.clear();
        correoController.clear();
        telefonoController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar proveedor❌')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión con el servidor 🌐')),
      );
    }
  }


  InputDecoration estiloCampo(String texto, IconData icono) {
    const colorPrincipal = Color.fromARGB(255, 1, 122, 116);

    return InputDecoration(
      labelText: texto,
      labelStyle: const TextStyle(
        color: colorPrincipal,
        fontWeight: FontWeight.bold,
      ),
      suffixIcon: Icon(icono, color: colorPrincipal),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: colorPrincipal, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
    );
  }

  Widget campo(String texto, IconData icono) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo obligatorio' : null,
        decoration: estiloCampo(texto, icono),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const colorPrincipal = Color.fromARGB(255, 1, 122, 116);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestionar proveedores"),
        backgroundColor: colorPrincipal,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrincipal,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proveedor guardado')),
              );
            }
          },
          child: const Text(
            "Guardar Proveedor",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              campo("Nombre del proveedor", Icons.person),
              campo("Dirección", Icons.location_on),
              campo("Correo electrónico", Icons.email),
              campo("Teléfono", Icons.phone),
             
            ],
          ),
        ),
      ),
    );
  }
}