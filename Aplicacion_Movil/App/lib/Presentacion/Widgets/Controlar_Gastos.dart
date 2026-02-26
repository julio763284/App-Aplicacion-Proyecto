import 'package:flutter/material.dart';

class Controlar_Gastos extends StatelessWidget {
  const Controlar_Gastos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),

        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // aqui va logica menu
          },
        ),

        title: const Text("Gastos"),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // aqui va logica buscar
            },
          ),

          IconButton(
            icon: const Icon(Icons.folder_copy_outlined),
            onPressed: () {
              // aqui va logica carpetas
            },
          ),

          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // aqui va logica opciones
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.payments_outlined,
                      size: 90,
                      color: Colors.amber,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Sin gastos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Presiona + para agregar",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            color: const Color(0xFF0D9488),
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Total: 0,00",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          // aqui va logica agregar gasto
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
