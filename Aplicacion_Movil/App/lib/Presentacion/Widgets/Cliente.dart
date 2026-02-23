import 'package:flutter/material.dart';

class Cliente extends StatelessWidget {
  const Cliente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 122, 116),
        title: Text("Cliente", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.white,),
          onPressed: (){print("buscar");}),
          IconButton(icon: Icon(Icons.sort_by_alpha, color: Colors.white),
          onPressed: (){print("Filtrar por Letra");}),
          IconButton(icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: (){print("Ver Opciones");})
        ],
        ),
        drawer: Drawer(),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color:Color.fromARGB(255, 1, 122, 116).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Color.fromARGB(255, 1, 122, 116) ,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Agregar Cliente",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Seleccionar + para agregar Clientes",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
       floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 1, 122, 116),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white,),
      )
    );
  }
}