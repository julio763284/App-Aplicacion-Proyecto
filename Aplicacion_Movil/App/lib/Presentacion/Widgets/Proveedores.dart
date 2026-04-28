import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/NuevoProveedor.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Proveedores extends StatelessWidget {
  const Proveedores({super.key});
  final String url = "http://10.2.124.134:5000/proveedores";

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: accentTeal.withOpacity(0.2),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.sort, color: Colors.greenAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "PROVEEDORES",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.white70),
          SizedBox(width: 15),
          Icon(Icons.sort_by_alpha, color: Colors.white70),
          SizedBox(width: 15),
          Icon(Icons.more_vert, color: Colors.white70),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: -40,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: accentTeal.withOpacity(0.03),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: const Color(0xFF162A2D),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_shipping_rounded,
                      size: 80,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "AGREGAR PROVEEDORES",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Toca el botón + para comenzar",
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        foregroundColor: primaryDark,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Nuevoproveedor(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}