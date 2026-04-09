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
            const SnackBar(content: Text("acceso concedido"), backgroundColor: Colors.green),
          );
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("error en los datos"), backgroundColor: Colors.red),
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
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
                width: 340, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "¡Bienvenido!",
                      style: TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.w900, 
                        color: Color(0xFF017A74),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "ingresa a tu cuenta",
                      style: TextStyle(fontSize: 13, color: Colors.black38),
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(
                      controller: widget.userController,
                      hint: "correo o teléfono",
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: widget.passController,
                      hint: "contraseña",
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.read<AutenticacionBloc>().add(EventoOlvidarContrasena(widget.userController.text)),
                        child: const Text(
                          "¿olvidaste tu contraseña?",
                          style: TextStyle(color: Color(0xFF017A74), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    BlocBuilder<AutenticacionBloc, Autenticacionestados>(
                      builder: (context, state) {
                        if (state is Logincargando) {
                          return const CircularProgressIndicator(color: Color(0xFF017A74));
                        }
                        return Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(color: Color(0x33017A74), blurRadius: 10, offset: Offset(0, 5)),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF017A74),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0, 
                            ),
                            onPressed: () {
                              context.read<AutenticacionBloc>().add(
                                Ingresar(widget.userController.text, widget.passController.text),
                              );
                            },
                            child: const Text("Iniciar", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                    
                    const Text("------------------------ o accede con -------------------------", style: TextStyle(color: Colors.black26, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon(
                          isImage: true,
                          imagePath: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                        ),
                        const SizedBox(width: 20),
                        _socialIcon(icon: Icons.facebook, color: const Color(0xFF1877F2)),
                        const SizedBox(width: 20),
                        _socialIcon(icon: Icons.phone_android_rounded, color: Colors.green),
                      ],
                    ),

                    const SizedBox(height: 25),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿nuevo aquí?", style: TextStyle(color: Colors.black45, fontSize: 13)),
                        TextButton(
                          onPressed: () => context.read<AutenticacionBloc>().add(EventoRegistrarse()),
                          child: const Text(
                            "crear cuenta",
                            style: TextStyle(color: Color(0xFF017A74), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscureText : false,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF017A74), size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 18),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _socialIcon({IconData? icon, Color? color, bool isImage = false, String? imagePath}) {
    return InkWell(
      onTap: () {}, 
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: isImage 
          ? Image.network(imagePath!, fit: BoxFit.contain)
          : Icon(icon, color: color, size: 22),
      ),
    );
  }
}