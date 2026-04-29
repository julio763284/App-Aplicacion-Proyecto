import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/core/config.dart';

class Nuevoproveedor extends StatelessWidget {
  Nuevoproveedor({super.key});

  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();

  final String url = ApiConfig.url('/registro_proveedor');

  Future<void> guardarProveedor(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombreController.text,
          "direccion": direccionController.text,
          "gmail": correoController.text,
          "telefono": telefonoController.text,
        }),
      );

      if (response.statusCode == 200) {
        _mensaje(context, 'Proveedor registrado con éxito ✅', Colors.greenAccent);
        nombreController.clear();
        direccionController.clear();
        correoController.clear();
        telefonoController.clear();
      } else {
        _mensaje(context, 'Error en el registro ❌', Colors.redAccent);
      }
    } catch (e) {
      _mensaje(context, 'Error de red 🌐', Colors.orangeAccent);
    }
  }

  void _mensaje(BuildContext context, String t, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t, style: const TextStyle(color: Color(0xFF0D1B1E), fontWeight: FontWeight.bold)),
        backgroundColor: c,
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
          "NUEVO PROVEEDOR",
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Datos de Suministro", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildField("Razón Social / Nombre", Icons.business_outlined, nombreController),
              _buildField("Dirección Distribuidora", Icons.local_post_office_outlined, direccionController),
              _buildField("Correo de Contacto", Icons.email_outlined, correoController, type: TextInputType.emailAddress),
              _buildField("Teléfono de Pedidos", Icons.phone_callback_rounded, telefonoController, type: TextInputType.phone),
              const SizedBox(height: 40),
              _buildSubmit(context, accentTeal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, IconData icon, TextEditingController ctrl, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: TextFormField(
            controller: ctrl,
            keyboardType: type,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              prefixIcon: Icon(icon, color: Colors.greenAccent, size: 20),
              filled: true,
              fillColor: Colors.white.withOpacity(0.03),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.05)), borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF017A74)), borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmit(BuildContext context, Color color) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          guardarProveedor(context);
        }
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [color, const Color(0xFF00C9B1)]),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: const Center(
          child: Text("REGISTRAR PROVEEDOR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}