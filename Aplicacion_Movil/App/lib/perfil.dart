import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/login.dart';

class PerfilPage extends StatelessWidget {
  final String nombre;
  final String email;

  const PerfilPage({super.key, required this.nombre, required this.email});

  static const Color primaryColor = Color(0xFF017A74);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),

      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Mi Perfil"),
      ),

      body: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔥 FOTO CIRCULAR
              const CircleAvatar(
                radius: 55,
                backgroundColor: primaryColor,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),

              const SizedBox(height: 20),

              // 🔥 NOMBRE DINÁMICO
              Text(
                nombre,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // 🔥 EMAIL DINÁMICO
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // 🔥 BOTÓN CERRAR SESIÓN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Cerrar Sesión",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
