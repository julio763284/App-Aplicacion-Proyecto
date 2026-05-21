import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:http/http.dart' as http;

class OlvidarContrasena2 extends StatefulWidget {
  final String email; // Recibimos el email de la pantalla anterior

  const OlvidarContrasena2({super.key, required this.email});

  @override
  State<OlvidarContrasena2> createState() => _OlvidarContrasena2State();
}

class _OlvidarContrasena2State extends State<OlvidarContrasena2> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool _estaCargando = false;
  bool _obscureText = true;

  Future<void> _restablecerContrasena() async {
    final String codigo = codeController.text.trim();
    final String password = newPassController.text.trim();
    final String confirmPassword = confirmPassController.text.trim();

    if (codigo.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _mostrarMensaje("Por favor, completa todos los campos", esError: true);
      return;
    }

    if (password != confirmPassword) {
      _mostrarMensaje("Las contraseñas no coinciden", esError: true);
      return;
    }

    setState(() => _estaCargando = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.url('/verificar_y_cambiar_password')),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "codigo": codigo,
          "nuevo_password": password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        _mostrarMensaje("Contraseña actualizada con éxito");
        if (!mounted) return;
        // Regresa al Login (primera pantalla)
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        _mostrarMensaje(
          data['message'] ?? "Error al actualizar",
          esError: true,
        );
      }
    } catch (e) {
      _mostrarMensaje("Error de conexión", esError: true);
    } finally {
      setState(() => _estaCargando = false);
    }
  }

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
      resizeToAvoidBottomInset: true,
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
                Icon(
                  Icons.security_update_good,
                  size: 80,
                  color: Colors.cyanAccent.withOpacity(0.8),
                ),
                const SizedBox(height: 20),
                const Text(
                  "RESTABLECER CONTRASEÑA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Enviamos un código a ${widget.email}",
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildStyledField(
                            codeController,
                            "Código recibido",
                            Icons.verified_user_outlined,
                          ),
                          const SizedBox(height: 20),
                          _buildStyledField(
                            newPassController,
                            "Nueva contraseña",
                            Icons.lock_outline,
                            isPass: true,
                          ),
                          const SizedBox(height: 20),
                          _buildStyledField(
                            confirmPassController,
                            "Confirmar contraseña",
                            Icons.lock_reset_outlined,
                            isPass: true,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyanAccent,
                                foregroundColor: const Color(0xFF0D1B1E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: _estaCargando
                                  ? null
                                  : _restablecerContrasena,
                              child: _estaCargando
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFF0D1B1E),
                                    )
                                  : const Text(
                                      "ACTUALIZAR",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
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
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white.withOpacity(0.5),
                    size: 18,
                  ),
                  label: Text(
                    "Regresar",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPass = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPass ? _obscureText : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20),
        suffixIcon: isPass
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white24,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
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
