import 'dart:convert';
import 'dart:ui';
import 'dart:typed_data'; 
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o/appbar.dart';
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

  Widget _mostrarImagenNexus(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return Container(
        color: Colors.black26,
        child: const Icon(Icons.inventory, color: nexusBorder, size: 40),
      );
    }

    try {
      String cleanBase64 = base64String.contains(',') 
          ? base64String.split(',').last 
          : base64String;

      Uint8List bytes = base64Decode(cleanBase64);
      
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.red),
      );
    } catch (e) {
      return const Icon(Icons.error, color: Colors.orange);
    }
  }

  void _mostrarOpciones(BuildContext context, dynamic producto) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: nexusCard.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: nexusCyan.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        producto['nombre'].toString().toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Divider(color: nexusCyan.withOpacity(0.15), height: 1),
                    Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            leading: const Icon(Icons.edit_outlined, color: nexusCyan, size: 22),
                            title: const Text("EDITAR PRODUCTO", style: TextStyle(color: Colors.white, fontSize: 13)),
                            onTap: () {
                              Navigator.pop(context);
                              _mostrarDialogoEditar(context, producto);
                            },
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            leading: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent, size: 22),
                            title: const Text("ELIMINAR DE INVENTARIO", style: TextStyle(color: Colors.white, fontSize: 13)),
                            onTap: () {
                              Navigator.pop(context);
                              eliminarProducto(producto['id_producto']);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
      appBar: CustomAppBar(
        conteoNotificaciones: 0,
        onActualizarNotificaciones: () {},
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: nexusCyan))
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final producto = _filteredProducts[index];

                return GestureDetector(
                  onLongPress: () => _mostrarOpciones(context, producto),
                  child: Container(
                    decoration: BoxDecoration(
                      color: nexusCard,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: nexusBorder, width: 1.2),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // CAMBIADO: Usamos la función de decodificación Base64
                              child: _mostrarImagenNexus(producto['imagen']),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto['nombre'].toString().toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text("\$ :   ${producto['precio']}", style: const TextStyle(color: nexusCyan, fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        color: nexusCard,
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: nexusBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: nexusCyan.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.analytics_outlined, color: nexusCyan, size: 16),
                    const SizedBox(width: 10),
                    Text("TOTAL: ${_filteredProducts.length}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: nexusBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: nexusCyan, width: 2)),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Nuevoproducto())).then((_) => obtenerProductos()),
        child: const Icon(Icons.add_box_outlined, color: nexusCyan),
      ),
    );
  }

  Future<void> eliminarProducto(int id) async {
    try {
      final String url = ApiConfig.url('/producto/$id');
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) obtenerProductos();
    } catch (e) {}
  }

  void _mostrarDialogoEditar(BuildContext context, dynamic producto) {
    final nombreCtrl = TextEditingController(text: producto['nombre'].toString());
    final descCtrl = TextEditingController(text: producto['descripcion']?.toString() ?? '');
    final precioCtrl = TextEditingController(text: producto['precio'].toString());
    final cantCtrl = TextEditingController(text: producto['cantidad'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: nexusCard,
        title: const Text("EDITAR PRODUCTO", style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombreCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Nombre", labelStyle: TextStyle(color: nexusCyan))),
              TextField(controller: descCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Descripción", labelStyle: TextStyle(color: nexusCyan))),
              TextField(controller: precioCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Precio", labelStyle: TextStyle(color: nexusCyan))),
              TextField(controller: cantCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Cantidad", labelStyle: TextStyle(color: nexusCyan))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR", style: TextStyle(color: Colors.redAccent))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final url = ApiConfig.url('/producto/${producto['id_producto']}');
                final res = await http.put(
                  Uri.parse(url),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "nombre": nombreCtrl.text,
                    "descripcion": descCtrl.text,
                    "precio": double.tryParse(precioCtrl.text) ?? 0.0,
                    "cantidad": int.tryParse(cantCtrl.text) ?? 0,
                  }),
                );
                if (res.statusCode == 200) obtenerProductos();
              } catch (e) {}
            },
            child: const Text("GUARDAR", style: TextStyle(color: nexusCyan)),
          ),
        ],
      ),
    );
  }
}