import 'package:flutter/material.dart';
import 'package:gestor/HomePage.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/perfil.dart'; 

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  bool _isSearching = false; 
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1B1E),
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF017A74).withOpacity(0.2),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:  
             const Text(
                "NEXUS INVENTORY", 
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)
              ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.white70),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                    child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 8), textAlign: TextAlign.center),
                  ),
                )
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationView()));
            },
          ),

          IconButton(
            icon: const Icon(Icons.person_pin, color: Colors.greenAccent, size: 28),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => PerfilPage(
                    nombre: 'JHOLIAN MANUEL', 
                    email: 'jholianmanuel@gmail.com', 
                    urlImagen: 'https://avatars.githubusercontent.com/u/12345678?v=4',
                  )
                )
              ); 
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: const HomepageBodyLayout(),
    );
  }
}