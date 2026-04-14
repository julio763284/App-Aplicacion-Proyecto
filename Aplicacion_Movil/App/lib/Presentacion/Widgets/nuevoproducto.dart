import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Nuevoproducto extends StatelessWidget {
  Nuevoproducto({super.key});

  final _formKey = GlobalKey<FormState>();
  final nombreproductoController = TextEditingController();
  final codigodebarrasController = TextEditingController();
  final descripcionController = TextEditingController();
  final cantidadController = TextEditingController();

  final String url = "http://10.2.139.243:3000/producto";

  Future<void> guardarProducto(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombreproductoController.text,
          "direccion": codigodebarrasController.text, 
          "correo": descripcionController.text,
          "telefono": cantidadController.text,
        }),
      );

      if (response.statusCode == 200) {
        _notificar(context, 'Producto guardado en Nexus ✅', Colors.greenAccent);
        _limpiar();
      } else {
        _notificar(context, 'Error al guardar productos ❌', Colors.redAccent);
      }
    } catch (e) {
      _notificar(context, 'Error de conexión 🌐', Colors.orangeAccent);
    }
  }

  void _limpiar() {
    nombreproductoController.clear();
    codigodebarrasController.clear();
    descripcionController.clear();
    cantidadController.clear();
  }

  void _notificar(BuildContext context, String msg, Color col) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Color(0xFF0D1B1E), fontWeight: FontWeight.bold)),
      backgroundColor: col,
      behavior: SnackBarBehavior.floating,
    ));
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
        title: const Text("NUEVO PRODUCTO", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.add_shopping_cart, size: 60, color: Colors.greenAccent),
              const SizedBox(height: 30),
              _campoNexus("Nombre del Producto", Icons.inventory_2_outlined, nombreproductoController),
              _campoNexus("Código de Barras", Icons.qr_code_scanner, codigodebarrasController),
              _campoNexus("Descripción", Icons.description_outlined, descripcionController),
              _campoNexus("Cantidad en Stock", Icons.numbers, cantidadController, type: TextInputType.number),
              const SizedBox(height: 40),
              _botonGuardar(context, accentTeal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoNexus(String label, IconData icon, TextEditingController ctr, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: ctr,
        keyboardType: type,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          prefixIcon: Icon(icon, color: Colors.greenAccent, size: 22),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF017A74))),
        ),
      ),
    );
  }

  Widget _botonGuardar(BuildContext context, Color color) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(colors: [color, const Color(0xFF00C9B1)]),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        onPressed: () => guardarProducto(context),
        child: const Text("REGISTRAR PRODUCTO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}