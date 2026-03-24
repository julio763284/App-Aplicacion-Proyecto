import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gestor/Presentacion/Widgets/api.dart';

class GestionInventarioView extends StatelessWidget {
  const GestionInventarioView({super.key});

  static const Color primaryColor = Color(0xFF017A74);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Gestión de Inventario"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
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
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        children: [
          Icon(icono, color: GestionInventarioView.primaryColor, size: 28),
          const SizedBox(height: 8),
          Text(valor,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
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
    return FutureBuilder<List<Movimiento>>(
      future: movimientosFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final movimientos = snapshot.data!;

        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: movimientos
                    .map((m) => FlSpot(m.mes.toDouble() - 1, m.total))
                    .toList(),
                isCurved: true,
                barWidth: 4,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: true),
              ),
            ],
          ),
        );
      },
    );
  }
}