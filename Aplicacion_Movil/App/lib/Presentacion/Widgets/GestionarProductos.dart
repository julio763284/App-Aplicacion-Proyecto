import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/nuevoproducto.dart';

class Gestionarproductos extends StatefulWidget {
  const Gestionarproductos({super.key});

  @override
  State<Gestionarproductos> createState() => _GestionarproductosState();
}

class _GestionarproductosState extends State<Gestionarproductos> {
  static const Color nexusBg = Color(0xFF031A1A);
  static const Color nexusCard = Color(0xFF0A2426);
  static const Color nexusCyan = Color(0xFF00FBFF);
  static const Color nexusBorder = Color(0xFF163D3F);

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allProducts = [];
  List<dynamic> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    obtenerProductos();
  }

  Future<void> obtenerProductos() async {
    try {
      final String apiUrl = ApiConfig.url('/productos');
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _allProducts = data;
          _filteredProducts = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((p) => p['nombre'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nexusBg,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: nexusBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearching
              ? TextField(
                  key: const ValueKey('search'),
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "BUSCAR RECURSO...",
                    hintStyle: TextStyle(color: nexusCyan.withOpacity(0.3)),
                    border: InputBorder.none,
                  ),
                  onChanged: _filterProducts,
                )
              : const Text("SISTEMA DE INVENTARIO", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: nexusCyan),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _filteredProducts = _allProducts;
              }
            }),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: nexusCyan))
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Más margen lateral
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 18, // Más espacio entre tarjetas
                mainAxisSpacing: 18,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final producto = _filteredProducts[index];
                return Container(
                  decoration: BoxDecoration(
                    color: nexusCard,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: nexusBorder, width: 1.2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Todo a la izquierda
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: producto['imagen'] != null 
                              ? Image.network(producto['imagen'], fit: BoxFit.cover, width: double.infinity)
                              : Container(color: Colors.black26, child: const Icon(Icons.inventory, color: nexusBorder, size: 40)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Alineación izquierda
                          children: [
                            Text(
                              producto['nombre'].toString().toUpperCase(), 
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis
                            ),
                            const SizedBox(height: 6),
                            // Precio con espacio/puntos solicitado
                            Text(
                              "\$ :  ${producto['precio']}", 
                              style: const TextStyle(color: nexusCyan, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        color: nexusCard,
        elevation: 0,
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: nexusCyan.withOpacity(0.2), width: 0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: nexusBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: nexusCyan.withOpacity(0.5))
                ),
                child: Row(
                  children: [
                    const Icon(Icons.analytics_outlined, color: nexusCyan, size: 16),
                    const SizedBox(width: 10),
                    const Text("TOTAL PRODUCTOS :", 
                      style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(width: 15),
                    Text("${_filteredProducts.length}", 
                      style: const TextStyle(color: nexusCyan, fontSize: 18, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: nexusBg,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), 
            side: const BorderSide(color: nexusCyan, width: 2)
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  Nuevoproducto())).then((_) => obtenerProductos()),
          child: const Icon(Icons.add_box_outlined, color: nexusCyan, size: 28),
        ),
      ),
    );
  }
}