import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/autenticacion/bloc_autenticacion.dart';
import '../../bloc/autenticacion/eventos_autenticacion.dart';

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
  // Variable para controlar la visibilidad de la contraseña
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 1, 122, 116),
            Color.fromARGB(255, 0, 168, 150),
          ],
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
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(2, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // LOGO
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 1, 122, 116),
                        Color.fromARGB(255, 0, 168, 150),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    size: 75,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Inventary Mobile",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 122, 116),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Gestión inteligente de inventario",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 30),

                // USUARIO
                TextField(
                  controller: widget.userController,
                  decoration: InputDecoration(
                    labelText: "Usuario",
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CONTRASEÑA MODIFICADA
                TextField(
                  controller: widget.passController,
                  obscureText: _isObscured, // Usa la variable de estado
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(Icons.lock),
                    // AQUÍ ESTÁ EL BOTÓN FUNCIONAL
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: const Color.fromARGB(255, 1, 122, 116),
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // BOTÓN INGRESAR
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 1, 122, 116),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                    ),
                    onPressed: () {
                      String user = widget.userController.text.trim();
                      String pass = widget.passController.text.trim();

                      if (user.isEmpty || pass.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Completa todos los campos"),
                          ),
                        );
                      } else {
                        context.read<AutenticacionBloc>().add(
                          Ingresar(user, pass),
                        );
                      }
                    },
                    child: const Text(
                      "Ingresar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // OLVIDÓ CONTRASEÑA
                TextButton(
                  onPressed: () {
                    context.read<AutenticacionBloc>().add(
                      EventoOlvidarContrasena(
                        widget.userController.text.trim(),
                      ),
                    );
                  },
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 1, 122, 116),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // REGISTRO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes cuenta? "),
                    TextButton(
                      onPressed: () {
                        context.read<AutenticacionBloc>().add(
                          EventoRegistrarse(),
                        );
                      },
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(
                          color: Color.fromARGB(255, 1, 122, 116),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
