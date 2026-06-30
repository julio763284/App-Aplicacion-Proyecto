import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o/appbar.dart';
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
    idProducto: json['id'] ?? json['id_producto'] ?? 0,
    nombre: json['nombre'] ?? 'Sin nombre',
    cantidad: json['stock'] ?? json['cantidad'] ?? 0,
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
  List<Producto> _todosLosProductos  = [];
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
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _todosLosProductos  = jsonData.map((item) => Producto.fromJson(item)).toList();
          _productosFiltrados = _todosLosProductos;
          _isLoading          = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filtrarBusqueda(String query) {
    setState(() {
      _productosFiltrados = _todosLosProductos
          .where((p) => p.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teal  = theme.colorScheme.primary;
    final cyan  = theme.colorScheme.secondary;

    return Scaffold(
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(
        conteoNotificaciones: 0,
        onActualizarNotificaciones: () {},
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: teal))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  _buildSummaryGrid(_todosLosProductos),
                  const SizedBox(height: 35),

                  // Barra de búsqueda
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: teal, size: 28),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filtrarBusqueda,
                            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                            decoration: InputDecoration(
                              hintText: "Escribe para buscar...",
                              hintStyle: theme.textTheme.bodyMedium,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.close, color: theme.dividerColor),
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
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTableHeader(),
                        if (_productosFiltrados.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(50),
                            child: Text("Sin resultados",
                                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18)),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _productosFiltrados.length,
                            separatorBuilder: (_, __) =>
                                Divider(color: theme.dividerColor.withOpacity(0.2), height: 1),
                            itemBuilder: (_, i) => _buildProductRow(_productosFiltrados[i]),
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
    final total    = productos.where((p) => p.cantidad > 0).length;
    final bajo     = productos.where((p) => p.cantidad < 10 && p.cantidad > 0).length;
    final agotados = productos.where((p) => p.cantidad <= 0).length;
    final teal     = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard("TOTAL",   total.toString(),    Icons.inventory_2, teal),
        _buildSummaryCard("BAJO",    bajo.toString(),     Icons.bolt,        Colors.orangeAccent),
        _buildSummaryCard("AGOTADO", agotados.toString(), Icons.block,       Colors.redAccent),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 15),
          Text(value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              )),
          Text(title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    final theme = Theme.of(context);
    final teal  = theme.colorScheme.primary;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.dividerColor.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Center(child: Text("PRODUCTO",
              style: TextStyle(color: teal, fontWeight: FontWeight.w900, fontSize: 13)))),
          VerticalDivider(color: theme.dividerColor.withOpacity(0.2), thickness: 1, indent: 15, endIndent: 15),
          Expanded(flex: 1, child: Center(child: Text("CANTIDAD",
              style: TextStyle(color: teal, fontWeight: FontWeight.w900, fontSize: 13)))),
          VerticalDivider(color: theme.dividerColor.withOpacity(0.2), thickness: 1, indent: 15, endIndent: 15),
          Expanded(flex: 1, child: Center(child: Text("ESTADO",
              style: TextStyle(color: teal, fontWeight: FontWeight.w900, fontSize: 13)))),
        ],
      ),
    );
  }

  Widget _buildProductRow(Producto prod) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(prod.nombre.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
            VerticalDivider(color: theme.dividerColor.withOpacity(0.1), thickness: 1, indent: 5, endIndent: 5),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(prod.cantidad.toString(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            VerticalDivider(color: theme.dividerColor.withOpacity(0.1), thickness: 1, indent: 5, endIndent: 5),
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
                  child: Text(prod.estado.toUpperCase(),
                      style: TextStyle(
                        color: prod.colorEstado,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}