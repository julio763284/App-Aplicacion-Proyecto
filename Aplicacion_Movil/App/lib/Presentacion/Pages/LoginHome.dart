import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor/HomePage2.dart'; 
import 'package:gestor/Presentacion/Widgets/vistaDeRegistrarse.dart';
import 'package:gestor/Presentacion/Widgets/olvidar_contrasena.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/estados_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/eventos_autenticacion.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  // --- NUEVO SISTEMA DE ALERTAS NEXUS (CON SALIDA LENTA) ---
  void _showNexusAlert(String message, Color color, IconData icon) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _NexusAlertWidget(
        message: message,
        color: color,
        icon: icon,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlayState.insert(overlayEntry);
  }

  void _manejarErrorLogin(BuildContext context, String mensaje) {
    final bool noRegistrado = mensaje.toLowerCase().contains("registrarse") || 
                               mensaje.toLowerCase().contains("no registrado");

    if (noRegistrado) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF0D1B1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("AVISO DE SISTEMA", style: TextStyle(color: Colors.cyanAccent, letterSpacing: 2, fontSize: 16)),
          content: Text(mensaje, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCELAR", style: TextStyle(color: Colors.white38)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: const Color(0xFF0D1B1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); 
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterView()));
              },
              child: const Text("REGISTRARME", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      // Aplicamos la alerta Nexus aquí también
      _showNexusAlert(mensaje.toUpperCase(), Colors.redAccent, Icons.gpp_bad_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF0D1B1E),
      body: BlocListener<AutenticacionBloc, Autenticacionestados>(
        listener: (context, state) {
          if (state is Estado_Registrarse) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterView()));
          } else if (state is EstadoOlvidarcontrasena) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OlvidarContrasenaPage()));
          } 
          else if (state is LoginExitoso) {
            _showNexusAlert("ACCESO CONCEDIDO", Colors.greenAccent, Icons.verified_user_rounded);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Homepage2()));
          } else if (state is LoginError) {
            _manejarErrorLogin(context, state.mensaje);
          }
        },
        child: BlocBuilder<AutenticacionBloc, Autenticacionestados>(
          builder: (context, state) {
            return _buildLoginUI(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildLoginUI(BuildContext context, Autenticacionestados state) {
    return Container(
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
              Icon(Icons.security, size: 80, color: Colors.cyanAccent.withOpacity(0.8)),
              const SizedBox(height: 20),
              const Text(
                "ACCESO AL SISTEMA",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 3
                ),
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
                        _buildStyledField(userController, "Usuario o Correo", Icons.person_outline),
                        const SizedBox(height: 20),
                        _buildStyledField(passController, "Contraseña", Icons.lock_outline, isPass: true),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const OlvidarContrasenaPage()));
                            },
                            child: Text(
                              "¿Olvidaste tu contraseña?",
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyanAccent,
                              foregroundColor: const Color(0xFF0D1B1E),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 5,
                            ),
                            onPressed: state is Logincargando 
                              ? null 
                              : () {
                                  context.read<AutenticacionBloc>().add(
                                    Ingresar(userController.text, passController.text)
                                  );
                                },
                            child: state is Logincargando
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF0D1B1E),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("INGRESAR", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterView()));
                },
                child: const Text(
                  "¿No tienes cuenta? Regístrate", 
                  style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledField(TextEditingController controller, String hint, IconData icon, {bool isPass = false}) {
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
                color: Colors.cyanAccent.withOpacity(0.5),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
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

// --- WIDGET DE ALERTA NEXUS (IGUAL AL DE REGISTRO PARA COHERENCIA) ---
class _NexusAlertWidget extends StatefulWidget {
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismiss;

  const _NexusAlertWidget({required this.message, required this.color, required this.icon, required this.onDismiss});

  @override
  State<_NexusAlertWidget> createState() => _NexusAlertWidgetState();
}

class _NexusAlertWidgetState extends State<_NexusAlertWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 1200), // Salida lenta
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInBack,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 30,
      right: 30,
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _controller,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: widget.color.withOpacity(0.5), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: widget.color, size: 28),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}