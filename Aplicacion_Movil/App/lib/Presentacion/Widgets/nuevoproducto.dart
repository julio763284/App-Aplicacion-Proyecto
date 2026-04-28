import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Nuevoproducto extends StatelessWidget {
  Nuevoproducto({super.key});

  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();
  final imagenController = TextEditingController();

  final String url = "http://10.2.127.40:5000/producto";

  Future<void> guardarProducto(BuildContext context) async {
    if (nombreController.text.isEmpty || precioController.text.isEmpty) {
      _notificar(context, 'Nombre y Precio son obligatorios ⚠️', Colors.orangeAccent);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombreController.text,
          "descripcion": descripcionController.text,
          "precio": double.tryParse(precioController.text) ?? 0.0,
          "cantidad": int.tryParse(cantidadController.text) ?? 0,
          "imagen": imagenController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _notificar(context, 'Producto guardado en Nexus ✅', Colors.greenAccent);
        _limpiar();
      } else {
        final errorData = jsonDecode(response.body);
        _notificar(context, 'Error: ${errorData["message"] ?? "No se pudo guardar"} ❌', Colors.redAccent);
      }
    } catch (e) {
      _notificar(context, 'Error de conexión con el servidor 🌐', Colors.redAccent);
    }
  }

  void _limpiar() {
    nombreController.clear();
    descripcionController.clear();
    precioController.clear();
    cantidadController.clear();
    imagenController.clear();
  }

  void _notificar(BuildContext context, String msg, Color col) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, 
        style: const TextStyle(color: Color(0xFF0D1B1E), fontWeight: FontWeight.bold)
      ),
      backgroundColor: col,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);

    return Scaffold(
      backgroundColor: primaryDark,
      // Usando el drawer que ya tienes configurado
      drawer: const CustomNexusDrawer(), 
      appBar: AppBar(
        backgroundColor: accentTeal.withOpacity(0.2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "REGISTRAR NUEVO PRODUCTO", 
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Icon(Icons.add_photo_alternate_outlined, size: 70, color: Colors.greenAccent),
              const SizedBox(height: 30),
              
              _campoNexus("Nombre del Producto", Icons.inventory_2_outlined, nombreController),
              _campoNexus("Descripción Breve", Icons.description_outlined, descripcionController),
              
              Row(
                children: [
                  Expanded(
                    child: _campoNexus("Precio", Icons.attach_money, precioController, type: TextInputType.number),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _campoNexus("Cantidad", Icons.numbers, cantidadController, type: TextInputType.number),
                  ),
                ],
              ),
              
              _campoNexus("URL de la Imagen (Opcional)", Icons.link, imagenController),
              
              const SizedBox(height: 30),
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
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.greenAccent, size: 20),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), 
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1))
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), 
            borderSide: const BorderSide(color: Color(0xFF017A74), width: 2)
          ),
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
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
        gradient: LinearGradient(
          colors: [color, const Color(0xFF00C9B1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        ),
        onPressed: () => guardarProducto(context),
        child: const Text(
          "CONFIRMAR REGISTRO", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)
        ),
      ),
    );
  }
}