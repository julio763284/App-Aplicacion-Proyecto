import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
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

  Future<void> obtenerPerfil() async {
    try {
      final String endpoint = ApiConfig.url('perfil?id=${widget.userId}');
      final res = await http.get(Uri.parse(endpoint));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          nombre = data['nombre'] ?? "";
          email = data['correo'] ?? "";
          urlImagen = data['imagen'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> subirImagen() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File file = File(image.path);
    List<int> bytes = await file.readAsBytes();
    String base64Image = base64Encode(bytes);

    try {
      final String endpoint = ApiConfig.url('subir_imagen');
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.userId, "imagen": base64Image}),
      );
      if (res.statusCode == 200) obtenerPerfil();
    } catch (e) {
      print("Error: $e");
    }
  }

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
        backgroundColor: const Color(0xFF0D1B1E),
        title: const Text(
          "Cerrar sesión",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "¿Deseas cerrar sesión?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sí", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) await logout();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B1E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PERFIL",
          style: TextStyle(color: Colors.white, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B1E), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildAvatar(),
                        const SizedBox(height: 20),
                        Text(
                          nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 40),
                        _cardInfo(Icons.email_outlined, "Correo", email),
                        _cardInfo(Icons.person_outline, "Usuario", nombre),
                        const Spacer(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.8),
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _confirmLogout,
                          child: const Text(
                            "CERRAR SESIÓN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: subirImagen,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: const Color(0xFF017A74),
            child: CircleAvatar(
              radius: 61,
              backgroundColor: const Color(0xFF0D1B1E),
              backgroundImage: (urlImagen != null && urlImagen!.isNotEmpty)
                  ? MemoryImage(base64Decode(urlImagen!))
                  : null,
              child: (urlImagen == null || urlImagen!.isEmpty)
                  ? const Icon(Icons.person, size: 70, color: Colors.white24)
                  : null,
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.cyanAccent,
            child: Icon(Icons.camera_alt, size: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _cardInfo(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
