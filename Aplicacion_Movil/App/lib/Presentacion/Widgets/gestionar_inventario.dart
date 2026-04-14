import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/api.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class GestionInventarioView extends StatelessWidget {
  const GestionInventarioView({super.key});

  // Colores del Estilo Nexus
  static const Color primaryDark = Color(0xFF0D1B1E);
  static const Color accentTeal = Color(0xFF017A74);
  static const Color neonGreen = Color(0xFF00FFC2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark, // 🔹 Fondo oscuro
      drawer: const CustomNexusDrawer(), // 🔹 Tu Drawer
      appBar: AppBar(
        backgroundColor: accentTeal.withOpacity(0.15),
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.sort, color: neonGreen), // 🔹 Icono Neón
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
        _ResumenCard(titulo: "Productos", valor: "1,245", icono: Icons.inventory_2),
        _ResumenCard(titulo: "Stock Bajo", valor: "23", icono: Icons.warning_amber),
        _ResumenCard(titulo: "Valor Total", valor: "\$12.5M", icono: Icons.attach_money),
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
    return ClipRRect( // 🔹 Estilo Glassmorphism
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
              Icon(icono, color: GestionInventarioView.neonGreen, size: 24), // 🔹 Icono Neón
              const SizedBox(height: 8),
              Text(
                valor,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5)),
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
  late Future<List<Movimiento>> movimientosFuture;

  @override
  void initState() {
    super.initState();
    movimientosFuture = InventarioService.obtenerMovimientos();
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
      child: FutureBuilder<List<Movimiento>>(
        future: movimientosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: GestionInventarioView.neonGreen));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white30)));
          }

          final movimientos = snapshot.data ?? [];
          if (movimientos.isEmpty) return const Center(child: Text("No hay datos"));

          final puntos = movimientos.map((m) => FlSpot((m.mes - 1).toDouble(), m.total)).toList();

          return LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
                drawVerticalLine: false,
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
                      if (value.toInt() < 0 || value.toInt() > 11) return const Text('');
                      return Text(meses[value.toInt()], style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text("${value.toInt()}", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10)),
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: puntos,
                  isCurved: true,
                  color: GestionInventarioView.neonGreen, // 🔹 Línea Neón
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [GestionInventarioView.neonGreen.withOpacity(0.2), Colors.transparent],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}