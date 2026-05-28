import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:gestor/Presentacion/Widgets/CustomAppBar.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';


class GestionInventarioView extends StatefulWidget {
  const GestionInventarioView({super.key});
  static const Color primaryDark = Color(0xFF0D1B1E);
  static const List<Color> chartColors = [
    Color(0xFF00FFC2),
    Color(0xFFFFD700),
    Color(0xFFFF6384),
    Color(0xFF36A2EB),
    Color(0xFF9966FF),
    Color(0xFF4BC0C0),
    Color(0xFFFF9F40),
  ];

  @override
  State<GestionInventarioView> createState() => _GestionInventarioViewState();
}

class _GestionInventarioViewState extends State<GestionInventarioView> {
  late Future<List<dynamic>> _futureProductos;

  @override
  void initState() {
    super.initState();
    _futureProductos = _fetchProductos();
  }

  Future<List<dynamic>> _fetchProductos() async {
    final response = await http.get(Uri.parse(ApiConfig.url('/productos')));
    return response.statusCode == 200 ? json.decode(response.body) : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GestionInventarioView.primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: const CustomAppBar(
        titulo: "PANEL DE CONTROL",
        conteoNotificaciones: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final productos = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCard("DISTRIBUCIÓN", _buildDonut(productos)),
                      _buildCard("STOCK", _buildBar(productos)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "LISTA DE PRODUCTOS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              ...productos.asMap().entries.map(
                (e) => _buildLeyendaCard(
                  e.value,
                  GestionInventarioView.chartColors[e.key %
                      GestionInventarioView.chartColors.length],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(String title, Widget child) => Container(
    width: 300,
    margin: const EdgeInsets.only(right: 15),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(child: child),
      ],
    ),
  );

  Widget _buildDonut(List productos) {
    if (productos.isEmpty) return const SizedBox();
    return PieChart(
      PieChartData(
        sections: productos.asMap().entries.map((e) {
          final cantidad = (e.value['cantidad'] ?? 0) is num
              ? (e.value['cantidad'] as num).toDouble()
              : 0.0;
          return PieChartSectionData(
            value: cantidad,
            color: GestionInventarioView
                .chartColors[e.key % GestionInventarioView.chartColors.length],
            radius: 50,
            title: "",
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBar(List productos) {
    if (productos.isEmpty) return const SizedBox();
    return BarChart(
      BarChartData(
        barGroups: productos.asMap().entries.map((e) {
          final cantidad = (e.value['cantidad'] ?? 0) is num
              ? (e.value['cantidad'] as num).toDouble()
              : 0.0;
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: cantidad,
                color:
                    GestionInventarioView.chartColors[e.key %
                        GestionInventarioView.chartColors.length],
                width: 15,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeyendaCard(Map p, Color color) => Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 15),
        Text(p['nombre'], style: const TextStyle(color: Colors.white)),
        const Spacer(),
        Text(
          "Stock: ${p['cantidad']}",
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
