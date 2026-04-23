import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/login2.dart';

class PerfilPage extends StatelessWidget {
  final String nombre;
  final String email;
  final String? urlImagen;
  
  final String telefono = "+57 300 123 4567";
  final String ubicacion = "Barranquilla, Colombia";
  final String fechaRegistro = "12 de Abril, 2026";

  PerfilPage({
    super.key, 
    required this.nombre, 
    required this.email, 
    this.urlImagen
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1B1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "DETALLES DE CUENTA", 
          style: TextStyle(color: Colors.white, letterSpacing: 3, fontWeight: FontWeight.bold, fontSize: 14)
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B1E), Color(0xFF001A18)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildAvatar(),
                const SizedBox(height: 15),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nombre.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, color: Colors.cyanAccent, size: 18),
                  ],
                ),
                const Text(
                  "ADMINISTRADOR DE SISTEMA",
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 35),

                _buildSectionHeader("INFORMACIÓN DE CONTACTO"),
                _buildFrostedSection(
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.email_outlined, "CORREO ELECTRÓNICO", email),
                      const Divider(color: Colors.white10, height: 30),
                      _buildInfoRow(Icons.phone_android_outlined, "TELÉFONO MÓVIL", telefono),
                      const Divider(color: Colors.white10, height: 30),
                      _buildInfoRow(Icons.location_on_outlined, "UBICACIÓN", ubicacion),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                _buildSectionHeader("SEGURIDAD Y SISTEMA"),
                _buildFrostedSection(
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.calendar_today_outlined, "MIEMBRO DESDE", fechaRegistro),
                      const Divider(color: Colors.white10, height: 30),
                      _buildInfoRow(Icons.lan_outlined, "IP DE ACCESO", "192.168.1.105"),
                      const Divider(color: Colors.white10, height: 30),
                      _buildInfoRow(Icons.data_thresholding_outlined, "ALMACENAMIENTO DB", "84% Utilizado"),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                _buildLogoutButton(context),
                const SizedBox(height: 20),
                const Text("Versión de Software 1.1.4", style: TextStyle(color: Colors.white24, fontSize: 10)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 10),
        child: Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 2),
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: const Color(0xFF017A74),
              backgroundImage: urlImagen != null ? NetworkImage(urlImagen!) : null,
              child: urlImagen == null 
                ? const Icon(Icons.person, size: 55, color: Colors.white) 
                : null,
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.cyanAccent, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, size: 15, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrostedSection({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.cyanAccent, size: 18),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 9, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) =>  LoginPage()),
          (route) => false,
        );
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.redAccent.withOpacity(0.1),
          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            "CERRAR SESIÓN SEGURA",
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}