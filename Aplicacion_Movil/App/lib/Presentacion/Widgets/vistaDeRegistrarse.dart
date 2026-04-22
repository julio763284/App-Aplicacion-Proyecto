import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';
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

  final String url = "http://10.2.137.120:3000/registro";
  final Color accentColor = const Color(0xFF00BFA5); // El mismo verde neón del login

  Future<void> registrarUsuario() async {
    // VALIDACIÓN BÁSICA
    if (nombreController.text.isEmpty || correoController.text.isEmpty) {
      _mostrarMensaje("Por favor rellena todos los campos");
      return;
    }

    if (!correoController.text.contains("@") || !correoController.text.contains(".com")) {
      _mostrarMensaje("Ingrese un correo válido");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _mostrarMensaje("Las contraseñas no coinciden");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombreController.text,
          "correo": correoController.text,
          "password": passwordController.text
        }),
      );

      if (response.statusCode == 200) {
        _mostrarMensaje("¡Registro exitoso!");
        _limpiarCampos();
        if (mounted) Navigator.pop(context);
      } else {
        _mostrarMensaje("Error al registrar usuario");
      }
    } catch (e) {
      _mostrarMensaje("Error de conexión: $e");
    }
  }

  void _limpiarCampos() {
    nombreController.clear();
    correoController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: mensaje.contains("exitoso") ? accentColor : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F11), // Mismo fondo oscuro
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                  const SizedBox(height: 20),
                  // Icono superior
                  Icon(Icons.person_add_alt, size: 70, color: accentColor),
                  const SizedBox(height: 15),
                  const Text(
                    "UNIRSE A NEXUS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Tarjeta Glassmorphism
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
                            _buildInputField(nombreController, "Nombre completo", Icons.person_outline),
                            const SizedBox(height: 20),
                            _buildInputField(correoController, "Correo electrónico", Icons.alternate_email),
                            const SizedBox(height: 20),
                            _buildInputField(passwordController, "Contraseña", Icons.lock_outline, isPass: true),
                            const SizedBox(height: 20),
                            _buildInputField(confirmPasswordController, "Confirmar contraseña", Icons.shield_outlined, isPass: true),
                            const SizedBox(height: 35),
                            
                            // Botón de Registro Neón
                            GestureDetector(
                              onTap: registrarUsuario,
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(colors: [accentColor, accentColor.withBlue(200)]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "CREAR CUENTA",
                                    style: TextStyle(
                                      color: Color(0xFF070F11),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes cuenta? ", style: TextStyle(color: Colors.white38)),
                        Text("Inicia Sesión", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon, {bool isPass = false}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        prefixIcon: Icon(icon, color: accentColor.withOpacity(0.7), size: 20),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: accentColor.withOpacity(0.5)),
        ),
      ),
    );
  }
}