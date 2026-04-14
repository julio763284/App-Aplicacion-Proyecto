import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/perfil.dart';

// He comentado esta línea para evitar el error de "Library not defined"
// import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Configuracion extends StatelessWidget {
  const Configuracion({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);

    return Scaffold(
      backgroundColor: primaryDark,
      // Usamos un Drawer genérico por ahora para que no de error
      drawer: const Drawer(child: Center(child: Text("Menú"))), 
      appBar: AppBar(
        backgroundColor: accentTeal.withOpacity(0.15),
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.sort, color: Colors.greenAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "AJUSTES",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: accentTeal.withOpacity(0.03),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const Text(
                "Preferencias del Sistema",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 22, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 30),
              
              const ItemAjusteNexus(icono: Icons.settings_outlined, texto: "General"),
              const ItemAjusteNexus(icono: Icons.visibility_outlined, texto: "Vista y Tema"),
              const ItemAjusteNexus(icono: Icons.business_outlined, texto: "Datos de Mi Empresa"),
              const ItemAjusteNexus(icono: Icons.payments_outlined, texto: "Gestión de Precios"),
              const ItemAjusteNexus(icono: Icons.qr_code_scanner_outlined, texto: "Escáner de Barras"),
              
              // REDIRECCIÓN A PERFIL CLIENTE
              ItemAjusteNexus(
                icono: Icons.person_outline, 
                texto: "Perfil de Usuario",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  PerfilPage(nombre: '', email: '',)),
                  );
                },
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white10),
              ),

              ItemAjusteNexus(
                icono: Icons.logout_rounded, 
                texto: "Cerrar Sesión", 
                esAlerta: true,
                onTap: () => print("Cerrando sesión..."),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget de los botones de ajuste
class ItemAjusteNexus extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool esAlerta;
  final VoidCallback? onTap;

  const ItemAjusteNexus({
    super.key, 
    required this.icono, 
    required this.texto, 
    this.esAlerta = false,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: esAlerta ? Colors.redAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05)
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: onTap, 
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: esAlerta ? Colors.redAccent.withOpacity(0.1) : const Color(0xFF017A74).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icono, 
                  color: esAlerta ? Colors.redAccent : Colors.greenAccent, 
                  size: 22
                ),
              ),
              title: Text(
                texto,
                style: TextStyle(
                  color: esAlerta ? Colors.redAccent : Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
            ),
          ),
        ),
      ),
    );
  }
}
