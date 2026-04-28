import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Nuevocliente extends StatelessWidget {
  Nuevocliente({super.key});

  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();

  final String url = "http://10.2.124.104:5000/registro_cliente";

  Future<void> guardarCliente(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombreController.text,
          "direccion_residencia": direccionController.text,
          "gmail_corporativo": correoController.text,
          "celular": telefonoController.text,
          "imagen": ""
        }),
      );

      if (response.statusCode == 201) {
        _notificar(context, 'Cliente guardado correctamente ✅', Colors.greenAccent);
        nombreController.clear();
        direccionController.clear();
        correoController.clear();
        telefonoController.clear();
      } else {
        _notificar(context, 'Error al guardar cliente ❌', Colors.redAccent);
      }
    } catch (e) {
      _notificar(context, 'Error de conexión con el servidor 🌐', Colors.orangeAccent);
    }
  }

  void _notificar(BuildContext context, String msj, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msj, style: const TextStyle(color: Color(0xFF0D1B1E), fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "REGISTRO",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.sort, color: Colors.greenAccent),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -40,
            right: -40,
            child: CircleAvatar(radius: 100, backgroundColor: accentTeal.withOpacity(0.03)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  const Text("Datos Personales", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 25),
                  _inputNexus("Nombre Completo", Icons.person_outline, nombreController),
                  _inputNexus("Dirección Residencia", Icons.map_outlined, direccionController),
                  _inputNexus("Email Corporativo", Icons.alternate_email, correoController, type: TextInputType.emailAddress),
                  _inputNexus("Celular", Icons.phone_iphone_rounded, telefonoController, type: TextInputType.phone),
                  const SizedBox(height: 40),
                  _btnGuardar(context, accentTeal),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputNexus(String label, IconData icon, TextEditingController ctrl, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
          prefixIcon: Icon(icon, color: Colors.greenAccent, size: 22),
          filled: true,
          fillColor: Colors.white.withOpacity(0.04),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF017A74)),
          ),
        ),
      ),
    );
  }

  Widget _btnGuardar(BuildContext context, Color color) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          guardarCliente(context);
        }
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [color, const Color(0xFF00C9B1)]),
        ),
        child: const Center(
          child: Text(
            "GUARDAR CLIENTE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
      ),
    );
  }
}