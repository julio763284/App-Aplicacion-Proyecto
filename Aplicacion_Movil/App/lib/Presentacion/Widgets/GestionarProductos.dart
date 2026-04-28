import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/nuevoproducto.dart';

class Gestionarproductos extends StatelessWidget {
  const Gestionarproductos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: CustomNexusDrawer(), 
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 71, 35),
        elevation: 0, 
        title: const Text(
          "productos", 
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  Nuevoproducto(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}