import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // IMPORTANTE: Verifica tu IP con 'ipconfig' en la PC
  final String url = "http://10.198.83.247:5000/registro_cliente";
  final Color accentColor = const Color(0xFF00BFA5);

  Future<void> registrarUsuario() async {
    if (nombreController.text.isEmpty || correoController.text.isEmpty || passwordController.text.isEmpty) {
      _snack("Rellena todos los campos", Colors.orange);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _snack("Las contraseñas no coinciden", Colors.red);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$url"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": nombreController.text,
          "email": correoController.text,
          "password": passwordController.text
        }),
      );

      final res = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _snack("¡Bienvenido a Nexus!", Colors.green);
        Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
      } else {
        _snack(res['message'] ?? "Error", Colors.red);
      }
    } catch (e) {
      _snack("Error de conexión con el servidor", Colors.red);
    }
  }

  void _snack(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F11),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomRight,
            radius: 1.5,
            colors: [accentColor.withOpacity(0.1), const Color(0xFF070F11)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Icon(Icons.person_add_alt, size: 70, color: accentColor),
                  const SizedBox(height: 15),
                  const Text("UNIRSE A NEXUS", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 3)),
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Column(
                          children: [
                            _field(nombreController, "Usuario", Icons.person_outline),
                            const SizedBox(height: 20),
                            _field(correoController, "Email", Icons.alternate_email),
                            const SizedBox(height: 20),
                            _field(passwordController, "Contraseña", Icons.lock_outline, isPass: true),
                            const SizedBox(height: 20),
                            _field(confirmPasswordController, "Confirmar", Icons.shield_outlined, isPass: true),
                            const SizedBox(height: 35),
                            ElevatedButton(
                              onPressed: registrarUsuario,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.black,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text("CREAR CUENTA", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String h, IconData i, {bool isPass = false}) {
    return TextField(
      controller: c,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: h,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(i, color: accentColor, size: 20),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}