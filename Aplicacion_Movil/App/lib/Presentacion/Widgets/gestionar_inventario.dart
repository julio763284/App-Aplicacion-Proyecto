import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class GestionInventarioView extends StatelessWidget {
  const GestionInventarioView({super.key});

  // Colores del Estilo Nexus
  static const Color primaryDark = Color(0xFF0D1B1E);
  static const Color accentTeal = Color(0xFF017A74);
  static const Color neonGreen = Color(0xFF00FFC2);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryDark,
        drawer: const CustomNexusDrawer(),
        appBar: AppBar(
          backgroundColor: accentTeal.withOpacity(0.15),
          elevation: 0,
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.sort, color: neonGreen),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const Text(
            "GESTIÓN DE INVENTARIO",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: const [
              _ResumenInventario(),
              SizedBox(height: 30),
              _GraficoInventario(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumenInventario extends StatelessWidget {
  const _ResumenInventario();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _ResumenCard(
          titulo: "Productos",
          valor: "1,245",
          icono: Icons.inventory_2,
        ),
        _ResumenCard(
          titulo: "Stock Bajo",
          valor: "23",
          icono: Icons.warning_amber,
        ),
        _ResumenCard(
          titulo: "Valor Total",
          valor: "\$12.5M",
          icono: Icons.attach_money,
        ),
      ],
    );
  }
}

class _ResumenCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _ResumenCard({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // 🔹 Estilo Glassmorphism
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 105,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Icon(
                icono,
                color: GestionInventarioView.neonGreen,
                size: 24,
              ), // 🔹 Icono Neón
              const SizedBox(height: 8),
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GraficoInventario extends StatefulWidget {
  const _GraficoInventario();

  @override
  State<_GraficoInventario> createState() => _GraficoInventarioState();
}

class _GraficoInventarioState extends State<_GraficoInventario> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
    );
  }
}
