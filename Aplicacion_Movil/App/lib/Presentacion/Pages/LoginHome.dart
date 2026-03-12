import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/autenticacion/bloc_autenticacion.dart';
import '../../bloc/autenticacion/eventos_autenticacion.dart';

class LoginHome extends StatelessWidget {
  const LoginHome({
    super.key,
    required this.userController,
    required this.passController,
  });

  final TextEditingController userController;
  final TextEditingController passController;

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
                  controller: userController,
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

                // CONTRASEÑA
                TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(Icons.lock),
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
                      String user = userController.text.trim();
                      String pass = passController.text.trim();

                      if (user.isEmpty || pass.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Completa todos los campos"),
                          ),
                        );
                      } else {
                        // AQUÍ SE ENVÍA EL EVENTO AL BLOC
                        context.read<AutenticacionBloc>().add(
                          Ingresar(user, pass ),
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
                    context.read<AutenticacionBloc>().add(EventoOlvidarContrasena(userController.text.trim()));
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
                    context.read<AutenticacionBloc>().add(EventoRegistrarse());
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