import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Nuevocliente extends StatelessWidget {
  Nuevocliente({super.key});

  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();

  static const Color colorPrincipal = Color.fromARGB(255, 1, 122, 116);

  final String url = "http://10.2.137.120:3000/clientes"; 

  Future<void> guardarCliente(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombreController.text,
          "direccion": direccionController.text,
          "correo": correoController.text,
          "telefono": telefonoController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente guardado correctamente ✅')),
        );

        nombreController.clear();
        direccionController.clear();
        correoController.clear();
        telefonoController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar cliente ❌')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión con el servidor 🌐')),
      );
    }
  }

  InputDecoration estiloCampo(String texto, IconData icono) {
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

  Widget campo(String texto, IconData icono, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo obligatorio' : null,
        decoration: estiloCampo(texto, icono),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo cliente"),
        backgroundColor: colorPrincipal,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrincipal,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              guardarCliente(context);
            }
          },
          child: const Text("Guardar Cliente",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
      body: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 700),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                campo("Nombre", Icons.person, nombreController),
                campo("Dirección", Icons.location_on, direccionController),
                campo("Correo electrónico", Icons.email, correoController),
                campo("Número de teléfono", Icons.add_ic_call, telefonoController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}