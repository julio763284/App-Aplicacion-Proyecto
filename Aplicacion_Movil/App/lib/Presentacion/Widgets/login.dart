import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 
import 'package:gestor/HomePage2.dart'; 
import 'package:gestor/Presentacion/Widgets/Loading.dart';
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

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF00BFA5); 

    return Scaffold(
      backgroundColor: const Color(0xFF070F11), 
      body: BlocListener<AutenticacionBloc, Autenticacionestados>(
        listener: (context, state) {
          if (state is LoginExitoso) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Homepage2()));
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Credenciales incorrectas"), backgroundColor: Colors.redAccent),
            );
          }
        },
        child: BlocBuilder<AutenticacionBloc, Autenticacionestados>(
          builder: (context, state) {
            if (state is Logincargando) return const LoadingView();
            return _buildAdvancedLogin(context, primaryTeal);
          },
        ),
      ),
    );
  }

  Widget _buildAdvancedLogin(BuildContext context, Color accent) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [accent.withOpacity(0.1), const Color(0xFF070F11)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 60),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accent.withOpacity(0.5), width: 2),
                  boxShadow: [BoxShadow(color: accent.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)],
                ),
                child: Icon(Icons.hub_outlined, size: 60, color: accent),
              ),
              const SizedBox(height: 25),
              const Text("NEXUS INVENTORY", 
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4)),
              const Text("Bienvenido de nuevo", style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 50),

              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        _buildInputField(userController, "Usuario", Icons.alternate_email, accent),
                        const SizedBox(height: 20),
                        _buildInputField(passController, "Contraseña", Icons.lock_outline, accent, isPass: true),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.read<AutenticacionBloc>().add(EventoOlvidarContrasena("")),
                            child: const Text("¿Olvidaste la clave?", style: TextStyle(color: Colors.white38, fontSize: 12)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => context.read<AutenticacionBloc>().add(Ingresar(userController.text, passController.text)),
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(colors: [accent, accent.withBlue(200)]),
                              boxShadow: [BoxShadow(color: accent.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))],
                            ),
                            child: const Center(
                              child: Text("INICIAR SESIÓN", style: TextStyle(color: Color(0xFF070F11), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white10)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Text("O ENTRAR CON", style: TextStyle(color: Colors.white24, fontSize: 10))),
                  Expanded(child: Divider(color: Colors.white10)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(FontAwesomeIcons.google, Colors.redAccent, () {
                    // Acción Google
                  }),
                  const SizedBox(width: 25),
                  _buildSocialButton(FontAwesomeIcons.facebookF, Colors.blueAccent, () {
                    // Acción Facebook
                  }),
                ],
              ),
              
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿No tienes cuenta?", style: TextStyle(color: Colors.white38)),
                  TextButton(
                    onPressed: () => context.read<AutenticacionBloc>().add(EventoRegistrarse()),
                    child: Text("Regístrate", style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon, Color accent, {bool isPass = false}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(icon, color: accent.withOpacity(0.7), size: 20),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: accent.withOpacity(0.5))),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: FaIcon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}