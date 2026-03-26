import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gestor/Presentacion/Widgets/api.dart';

class GestionInventarioView extends StatelessWidget {
  const GestionInventarioView({super.key});


  final String url = "http://10.2.137.120:3000/movimientos";


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

        // 🔄 Cargando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ❌ Error
        if (snapshot.hasError) {
  return Center(
    child: Text("Error: ${snapshot.error}"),
  );
}

       final movimientos = snapshot.data ?? [];

if (movimientos.isEmpty) {
  return const Center(child: Text("No hay datos"));
}

        // 🔥 Convertir datos a puntos
        final puntos = movimientos.map((m) {
          return FlSpot(
            (m.mes - 1).toDouble(),
            m.total,
          );
        }).toList();

        return SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),

              // 🔥 Ejes (meses)
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                   getTitlesWidget: (value, meta) {
  const meses = [
    'Ene','Feb','Mar','Abr','May','Jun',
    'Jul','Ago','Sep','Oct','Nov','Dic'
  ];

  if (value.toInt() < 0 || value.toInt() > 11) {
    return const Text('');
  }

  return Text(
    meses[value.toInt()],
    style: const TextStyle(fontSize: 10),
  );
},
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),

              borderData: FlBorderData(show: false),

              lineBarsData: [
                LineChartBarData(
                  spots: puntos,
                  isCurved: true,
                  barWidth: 4,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}