import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/olvidar_contrasena2.dart';

class OlvidarContrasenaPage extends StatefulWidget {
  const OlvidarContrasenaPage({super.key});

  @override
  State<OlvidarContrasenaPage> createState() => _OlvidarContrasenaPageState();
}

class _OlvidarContrasenaPageState extends State<OlvidarContrasenaPage> {
  final TextEditingController emailController = TextEditingController();

  // Función para validar el formato del correo
  bool _esCorreoValido(String email) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
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
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Icon(Icons.lock_reset, size: 80, color: Colors.cyanAccent.withOpacity(0.8)),
                const SizedBox(height: 20),
                const Text(
                  "RECUPERAR CONTRASEÑA",
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
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.mail_outline, color: Colors.cyanAccent, size: 20),
                              hintText: "Correo electrónico",
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
                          ),
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
                                String email = emailController.text.trim();
                                if (email.isEmpty) {
                                  _mostrarMensaje("Ingresa tu correo electrónico", esError: true);
                                } else if (!_esCorreoValido(email)) {
                                  _mostrarMensaje("Ingresa un correo válido", esError: true);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OlvidarContrasena2(),
                                    ),
                                  );
                                }
                              },
                              child: const Text("ENVIAR CÓDIGO", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 35),
                
                // Botones inferiores con mejor estilo e iconos
                TextButton.icon(
                  onPressed: () {
                    String email = emailController.text.trim();
                    if (email.isEmpty) {
                      _mostrarMensaje("Ingresa tu correo para reenviar el código", esError: true);
                    } else if (!_esCorreoValido(email)) {
                      _mostrarMensaje("Ingresa un correo válido", esError: true);
                    } else {
                      _mostrarMensaje("Código reenviado correctamente");
                    }
                  },
                  icon: const Icon(Icons.refresh, color: Colors.cyanAccent, size: 18),
                  label: const Text(
                    "Reenviar código",
                    style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.5), size: 18),
                  label: Text(
                    "Volver al Login",
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
}