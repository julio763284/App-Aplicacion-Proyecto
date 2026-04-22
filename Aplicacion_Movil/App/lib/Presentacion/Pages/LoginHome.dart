import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor/HomePage2.dart'; 
import 'package:gestor/Presentacion/Widgets/Loading.dart';
import 'package:gestor/Presentacion/Widgets/vistaDeRegistrarse.dart';
import 'package:gestor/Presentacion/Widgets/olvidar_contrasena.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/estados_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/eventos_autenticacion.dart'; // Asegúrate de que este import existe

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      body: BlocListener<AutenticacionBloc, Autenticacionestados>(
        listener: (context, state) {
          // Si el estado cambia a Estado_Registrarse, navegamos a la vista de registro
          if (state is Estado_Registrarse) {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const RegisterView())
            );
          } else if (state is EstadoOlvidarcontrasena) {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const OlvidarContrasenaPage())
            );
          } else if (state is LoginExitoso) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (_) => const Homepage2())
            );
          }
        },
        child: BlocBuilder<AutenticacionBloc, Autenticacionestados>(
          builder: (context, state) {
            if (state is Logincargando) {
              return const LoadingView();
            }
            return _buildLoginUI(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoginUI(BuildContext context) {
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
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 3),
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
                        _buildStyledField(userController, "Usuario", Icons.person_outline),
                        const SizedBox(height: 20),
                        _buildStyledField(passController, "Contraseña", Icons.lock_outline, isPass: true),
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
                    
                              context.read<AutenticacionBloc>().add(
                                Ingresar(userController.text, passController.text)
                              );
                            },
                            child: const Text("INGRESAR", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
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
                  context.read<AutenticacionBloc>().add(EventoRegistrarse());
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