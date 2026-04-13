import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Gestionarproducto extends StatelessWidget {
  const Gestionarproducto({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF017A74).withOpacity(0.2),
        elevation: 0,
        title: const Text("DETALLE PRODUCTO", style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings_suggest_outlined, size: 80, color: Colors.greenAccent),
            const SizedBox(height: 20),
            const Text("MODO EDICIÓN", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Aquí puedes modificar los datos del producto", style: TextStyle(color: Colors.white.withOpacity(0.4))),
          ],
        ),
      ),
    );
  }
}