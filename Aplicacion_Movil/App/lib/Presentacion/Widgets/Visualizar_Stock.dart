import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Producto {
  final int idProducto;
  final String nombre;
  final int cantidad;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.cantidad,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'] ?? 0,
      nombre: json['nombre'] ?? 'Sin nombre',
      cantidad: json['cantidad'] ?? 0,
    );
  }

  String get estado {
    if (cantidad >= 10) return 'Disponible';
    if (cantidad > 0 && cantidad < 10) return 'Stock Bajo';
    return 'Agotado';
  }

  Color get colorEstado {
    if (cantidad >= 10) return Colors.greenAccent;
    if (cantidad > 0 && cantidad < 10) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}

class VisualizarStock extends StatefulWidget {
  const VisualizarStock({super.key});

  @override
  State<VisualizarStock> createState() => _VisualizarStockState();
}

class _VisualizarStockState extends State<VisualizarStock> {
  final primaryDark = const Color(0xFF0D1B1E);
  final cardDark = const Color(0xFF162A2D);
  final accentTeal = const Color(0xFF017A74);

  List<Producto> _todosLosProductos = [];
  List<Producto> _productosFiltrados = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  Future<void> _fetchProductos() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/productos')));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _todosLosProductos = jsonData.map((item) => Producto.fromJson(item)).toList();
          _productosFiltrados = _todosLosProductos;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filtrarBusqueda(String query) {
    setState(() {
      _productosFiltrados = _todosLosProductos
          .where((prod) => prod.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("INVENTARIO GENERAL",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            Text("Sincronizado en tiempo real", style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF017A74)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  _buildSummaryGrid(_todosLosProductos),
                  const SizedBox(height: 35),
                  
                  // BARRA DE BÚSQUEDA SIN BOTÓN
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: accentTeal, size: 28),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filtrarBusqueda,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: "Escribe para buscar...",
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white54),
                            onPressed: () {
                              _searchController.clear();
                              _filtrarBusqueda('');
                            },
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 35),
                  Container(
                    decoration: BoxDecoration(
                      color: cardDark,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      children: [
                        _buildTableHeader(),
                        if (_productosFiltrados.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(50),
                            child: Text("Sin resultados", style: TextStyle(color: Colors.white24, fontSize: 18)),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _productosFiltrados.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
                            itemBuilder: (context, index) => _buildProductRow(_productosFiltrados[index]),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryGrid(List<Producto> productos) {
    final total = productos.where((p) => p.cantidad > 0).length;
    final bajo = productos.where((p) => p.cantidad < 10 && p.cantidad > 0).length;
    final agotados = productos.where((p) => p.cantidad <= 0).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard("TOTAL", total.toString(), Icons.inventory_2, accentTeal),
        _buildSummaryCard("BAJO", bajo.toString(), Icons.bolt, Colors.orangeAccent),
        _buildSummaryCard("AGOTADO", agotados.toString(), Icons.block, Colors.redAccent),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 15),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Center(child: Text("PRODUCTO", style: TextStyle(color: accentTeal, fontWeight: FontWeight.w900, fontSize: 13)))),
          VerticalDivider(color: Colors.white.withOpacity(0.1), thickness: 1, indent: 15, endIndent: 15),
          Expanded(flex: 1, child: Center(child: Text("CANTIDAD", style: TextStyle(color: accentTeal, fontWeight: FontWeight.w900, fontSize: 13)))),
          VerticalDivider(color: Colors.white.withOpacity(0.1), thickness: 1, indent: 15, endIndent: 15),
          Expanded(flex: 1, child: Center(child: Text("ESTADO", style: TextStyle(color: accentTeal, fontWeight: FontWeight.w900, fontSize: 13)))),
        ],
      ),
    );
  }

  Widget _buildProductRow(Producto prod) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(flex: 1, child: Center(child: Text(prod.nombre.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)))),
            VerticalDivider(color: Colors.white.withOpacity(0.05), thickness: 1, indent: 5, endIndent: 5),
            Expanded(flex: 1, child: Center(child: Text(prod.cantidad.toString(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)))),
            VerticalDivider(color: Colors.white.withOpacity(0.05), thickness: 1, indent: 5, endIndent: 5),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: prod.colorEstado.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: prod.colorEstado.withOpacity(0.5)),
                  ),
                  child: Text(
                    prod.estado.toUpperCase(),
                    style: TextStyle(color: prod.colorEstado, fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}