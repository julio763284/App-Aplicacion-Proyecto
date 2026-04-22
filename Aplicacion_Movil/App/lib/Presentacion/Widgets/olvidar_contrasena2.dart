import 'dart:ui';
import 'package:flutter/material.dart';

class OlvidarContrasena2 extends StatefulWidget {
  const OlvidarContrasena2({super.key});

  @override
  State<OlvidarContrasena2> createState() => _OlvidarContrasena2State();
}

class _OlvidarContrasena2State extends State<OlvidarContrasena2> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(color: Colors.white)),
        backgroundColor: esError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Permite que suba al abrir el teclado
      backgroundColor: const Color(0xFF0D1B1E),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B1E), Color(0xFF003D33)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security_update_good, size: 80, color: Colors.cyanAccent.withOpacity(0.8)),
                const SizedBox(height: 20),
                const Text(
                  "RESTABLECER CONTRASEÑA",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 3),
                ),
                const SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          _buildStyledField(codeController, "Código recibido", Icons.verified_user_outlined),
                          const SizedBox(height: 20),
                          _buildStyledField(newPassController, "Nueva contraseña", Icons.lock_outline, isPass: true),
                          const SizedBox(height: 20),
                          _buildStyledField(confirmPassController, "Confirmar contraseña", Icons.lock_reset_outlined, isPass: true),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyanAccent,
                                foregroundColor: const Color(0xFF0D1B1E),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              onPressed: () {
                                if (codeController.text.isEmpty || 
                                    newPassController.text.isEmpty || 
                                    confirmPassController.text.isEmpty) {
                                  _mostrarMensaje("Por favor, completa todos los campos", esError: true);
                                } else if (newPassController.text != confirmPassController.text) {
                                  _mostrarMensaje("Las contraseñas no coinciden", esError: true);
                                } else {
                                  _mostrarMensaje("Contraseña actualizada con éxito");
                                  // Volver al inicio del Login
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                }
                              },
                              child: const Text("ACTUALIZAR", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.5), size: 18),
                  label: Text(
                    "Regresar",
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledField(TextEditingController controller, String hint, IconData icon, {bool isPass = false}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
      ),
    );
  }
}