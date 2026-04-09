import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/autenticacion/bloc_autenticacion.dart';
import '../../bloc/autenticacion/eventos_autenticacion.dart';
import '../../bloc/autenticacion/estados_autenticacion.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({
    super.key,
    required this.userController,
    required this.passController,
  });

  final TextEditingController userController;
  final TextEditingController passController;

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AutenticacionBloc, Autenticacionestados>(
      listener: (context, state) {
        if (state is LoginExitoso) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Acceso concedido"), backgroundColor: Colors.green),
          );
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Credenciales incorrectas"), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF017A74), Color(0xFF00A896)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(25),
                width: 370,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(2, 6)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF017A74), Color(0xFF00A896)]),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: const Icon(Icons.inventory_2, size: 75, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text("Inventary Mobile", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF017A74))),
                    const SizedBox(height: 30),
                    TextField(
                      controller: widget.userController,
                      decoration: InputDecoration(
                        labelText: "Correo electrónico",
                        prefixIcon: const Icon(Icons.mail_rounded),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: widget.passController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF017A74)),
                          onPressed: () => setState(() => _obscureText = !_obscureText),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<AutenticacionBloc, Autenticacionestados>(
                      builder: (context, state) {
                        if (state is Logincargando) {
                          return const CircularProgressIndicator();
                        }
                        return SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF017A74),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                            ),
                            onPressed: () {
                              context.read<AutenticacionBloc>().add(
                                Ingresar(widget.userController.text, widget.passController.text),
                              );
                            },
                            child: const Text("Ingresar", style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => context.read<AutenticacionBloc>().add(EventoOlvidarContrasena(widget.userController.text)),
                      child: const Text("¿Olvidaste tu contraseña?", style: TextStyle(color: Color(0xFF017A74), fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes cuenta? "),
                        TextButton(
                          onPressed: () => context.read<AutenticacionBloc>().add(EventoRegistrarse()),
                          child: const Text("Registrarse", style: TextStyle(color: Color(0xFF017A74), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}