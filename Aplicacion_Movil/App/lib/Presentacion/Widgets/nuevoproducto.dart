import 'dart:convert';
import 'dart:typed_data'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Nuevoproducto extends StatefulWidget {
  const Nuevoproducto({super.key});

  @override
  State<Nuevoproducto> createState() => _NuevoproductoState();
}

class _NuevoproductoState extends State<Nuevoproducto> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();
  
  Uint8List? _webImage; 
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selected = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 70,
    );
    if (selected != null) {
      final bytes = await selected.readAsBytes();
      setState(() {
        _webImage = bytes;
      });
    }
  }

  Future<void> guardarProducto(BuildContext context) async {
    if (nombreController.text.isEmpty || precioController.text.isEmpty) {
      _notificar(context, 'Nombre y Precio son obligatorios ⚠️', Colors.orangeAccent);
      return;
    }

    try {
      String base64Image = "";
      if (_webImage != null) {
        base64Image = base64Encode(_webImage!);
      }

      final response = await http.post(
        Uri.parse(ApiConfig.url('/producto')),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombreController.text,
          "descripcion": descripcionController.text,
          "precio": double.tryParse(precioController.text) ?? 0.0,
          "cantidad": int.tryParse(cantidadController.text) ?? 0,
          "imagen": base64Image,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _notificar(context, 'Producto guardado en Nexus ✅', Colors.greenAccent);
        _limpiar();
      } else {
        _notificar(context, 'Error en el servidor: ${response.statusCode}', Colors.redAccent);
      }
    } catch (e) {
      _notificar(context, 'Error de conexión 🌐', Colors.redAccent);
    }
  }

  void _limpiar() {
    nombreController.clear();
    descripcionController.clear();
    precioController.clear();
    cantidadController.clear();
    setState(() {
      _webImage = null;
    });
  }

  void _notificar(BuildContext context, String msg, Color col) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Color(0xFF0D1B1E), fontWeight: FontWeight.bold)),
        backgroundColor: col,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        centerTitle: true,
        title: const Text("REGISTRAR NUEVO PRODUCTO", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: _webImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.memory(_webImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image_search, size: 50, color: Colors.greenAccent),
                            SizedBox(height: 10),
                            Text("Galería", style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text("CÁMARA", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: accentTeal),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _campoNexus("Nombre del Producto", Icons.inventory_2_outlined, nombreController),
              _campoNexus("Descripción Breve", Icons.description_outlined, descripcionController),
              Row(
                children: [
                  Expanded(child: _campoNexus("Precio", Icons.attach_money, precioController, type: TextInputType.number)),
                  const SizedBox(width: 15),
                  Expanded(child: _campoNexus("Cantidad", Icons.numbers, cantidadController, type: TextInputType.number)),
                ],
              ),
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
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF017A74), width: 2)),
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
        child: const Text("CONFIRMAR REGISTRO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}