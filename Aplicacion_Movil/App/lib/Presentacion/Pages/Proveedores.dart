import 'package:flutter/material.dart';

class ProveedoresView extends StatelessWidget {
  const ProveedoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Aquí pones tu lógica
          },
        ),

        title: const Text("Proveedores"),

        actions: const [
          Icon(Icons.search),
          SizedBox(width: 15),
          Icon(Icons.sort_by_alpha),
          SizedBox(width: 15),
          Icon(Icons.more_vert),
          SizedBox(width: 10),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Colors.amber,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Agregar proveedores",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Toca el botón + para comenzar",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          // Tu lógica aquí
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
