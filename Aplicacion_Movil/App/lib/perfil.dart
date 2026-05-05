import 'dart:ui';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gestor/Presentacion/Pages/LoginHome.dart';

class PerfilPage extends StatefulWidget {
  final int userId;

  const PerfilPage({super.key, required this.userId});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String nombre = "";
  String email = "";
  String? urlImagen;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    obtenerPerfil();
  }

  // 🔥 OBTENER PERFIL
  Future<void> obtenerPerfil() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.2.139.37:5000/perfil?id=${widget.userId}"),
      );

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          nombre = data['nombre'] ?? "";
          email = data['correo'] ?? "";
          urlImagen = data['imagen']; // base64
          loading = false;
        });
      } else {
        print("❌ Error al cargar perfil");
        setState(() => loading = false);
      }
    } catch (e) {
      print("🔥 ERROR: $e");
      setState(() => loading = false);
    }
  }

  // 🔥 SUBIR IMAGEN REAL
  Future<void> subirImagen() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    List<int> bytes = await file.readAsBytes();
    String base64Image = base64Encode(bytes);

    try {
      final res = await http.post(
        Uri.parse("http://10.2.139.37:5000/subir_imagen"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.userId, "imagen": base64Image}),
      );

      if (res.statusCode == 200) {
        print("✅ Imagen subida");

        obtenerPerfil(); // 🔥 refresca perfil
      } else {
        print("❌ Error subiendo imagen");
      }
    } catch (e) {
      print(" ERROR SUBIENDO: $e");
    }
  }

  //  LOGOUT REAL
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Deseas cerrar sesión y volver al login?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1B1E),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("PERFIL", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B1E), Color(0xFF001A18)],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 🔥 FOTO PERFIL
                GestureDetector(
                  onTap: subirImagen,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF017A74),

                    backgroundImage: urlImagen != null
                        ? MemoryImage(base64Decode(urlImagen!)) // 🔥 CLAVE
                        : null,

                    child: urlImagen == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(email, style: const TextStyle(color: Colors.white54)),

                const SizedBox(height: 40),

                _cardInfo(Icons.email, "Correo", email),
                _cardInfo(Icons.person, "Usuario", nombre),

                const SizedBox(height: 40),

                // 🔥 LOGOUT REAL
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _confirmLogout,
                  child: const Text("Cerrar sesión"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardInfo(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54)),
              Text(value, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
