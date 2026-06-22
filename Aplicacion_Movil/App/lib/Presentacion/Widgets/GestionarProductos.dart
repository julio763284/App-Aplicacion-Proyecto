import 'dart:convert';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/nuevoproducto.dart';
import 'package:intl/intl.dart';

class Gestionarproductos extends StatefulWidget {
  const Gestionarproductos({super.key});

  @override
  State<Gestionarproductos> createState() => _GestionarproductosState();
}

class _GestionarproductosState extends State<Gestionarproductos> {
  // Acento fijo de marca: se mantiene igual en ambos temas
  static const Color nexusCyan = Color(0xFF00FBFF);

  String _formatearPrecio(dynamic precio) {
    final valor = double.tryParse(precio.toString()) ?? 0.0;
    final formatter = NumberFormat('#,##0', 'es_CO');
    return formatter.format(valor).replaceAll(',', '.');
  }

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

  void _confirmarEliminar(BuildContext context, dynamic producto) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "¿ELIMINAR PRODUCTO?",
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
        ),
        content: Text(
          "Esta acción eliminará '${producto['nombre']}' del inventario de forma permanente.",
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCELAR", style: theme.textTheme.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              eliminarProducto(producto['id']);
            },
            child: const Text(
              "ELIMINAR",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _mostrarImagenNexus(String? stringImagen, Color placeholderColor) {
    if (stringImagen == null || stringImagen.isEmpty) {
      return Container(
        color: placeholderColor.withOpacity(0.3),
        child: Icon(Icons.inventory, color: placeholderColor, size: 40),
      );
    }

    // NUEVO: Si es una URL de internet (como los links de Pexels en tu DB)
    if (stringImagen.startsWith('http://') ||
        stringImagen.startsWith('https://')) {
      return Image.network(
        stringImagen,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        // Si el link se cae o no hay internet, muestra un icono amigable
        errorBuilder: (context, error, stackTrace) => Container(
          color: placeholderColor.withOpacity(0.1),
          child: const Icon(
            Icons.broken_image,
            color: Colors.redAccent,
            size: 35,
          ),
        ),
        // Efecto de carga mientras descarga la imagen de internet
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: nexusCyan,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    // Si no es URL, asume que es una cadena Base64 (como lo tenías originalmente)
    try {
      String cleanBase64 = stringImagen.contains(',')
          ? stringImagen.split(',').last
          : stringImagen;

      Uint8List bytes = base64Decode(cleanBase64);

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.red),
      );
    } catch (e) {
      return const Icon(Icons.error, color: Colors.orange);
    }
  }

  void _mostrarOpciones(BuildContext context, dynamic producto) {
    final theme = Theme.of(context);
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
                  color: theme.cardColor.withOpacity(0.9),
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
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Divider(color: theme.dividerColor, height: 1),
                    Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 5,
                            ),
                            leading: const Icon(
                              Icons.edit_outlined,
                              color: nexusCyan,
                              size: 22,
                            ),
                            title: Text(
                              "EDITAR PRODUCTO",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _mostrarDialogoEditar(context, producto);
                            },
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 5,
                            ),
                            leading: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            title: const Text(
                              "ELIMINAR DE INVENTARIO",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _confirmarEliminar(context, producto);
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
          .where(
            (p) => p['nombre'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: theme.dividerColor,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
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
                                  child: _mostrarImagenNexus(
                                    producto['imagen_url'],
                                    theme.dividerColor,
                                  ),
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
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    producto['descripcion']?.toString() ?? '',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 10,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "\$ ${_formatearPrecio(producto['precio_venta'])}",
                                    style: const TextStyle(
                                      color: nexusCyan,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botón visible de eliminar, esquina superior derecha
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => _confirmarEliminar(context, producto),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      // Botón visible de editar, esquina superior izquierda
                      Positioned(
                        top: 6,
                        left: 6,
                        child: GestureDetector(
                          onTap: () => _mostrarDialogoEditar(context, producto),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: nexusCyan,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        color: theme.cardColor,
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: nexusCyan.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.analytics_outlined,
                      color: nexusCyan,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "TOTAL: ${_filteredProducts.length}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: nexusCyan, width: 2),
        ),
        onPressed: () async {
          // Esperamos a que la pantalla se cierre
          final bool? recargar = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Nuevoproducto()),
          );

          // Si volvió con un valor true, refrescamos de una vez
          if (recargar == true) {
            obtenerProductos();
          }
        },
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
    final theme = Theme.of(context);
    final nombreCtrl = TextEditingController(
      text: producto['nombre'].toString(),
    );
    final descCtrl = TextEditingController(
      text: producto['descripcion']?.toString() ?? '',
    );
    final precioCompraCtrl = TextEditingController(
      text: producto['precio_compra'].toString(),
    );
    final precioVentaCtrl = TextEditingController(
      text: producto['precio_venta'].toString(),
    );
    final stockCtrl = TextEditingController(text: producto['stock'].toString());
    final stockMinimoCtrl = TextEditingController(
      text: producto['stock_minimo'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text("EDITAR PRODUCTO", style: theme.textTheme.bodyLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreCtrl,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  labelStyle: TextStyle(color: nexusCyan),
                ),
              ),
              TextField(
                controller: descCtrl,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  labelStyle: TextStyle(color: nexusCyan),
                ),
              ),
              TextField(
                controller: precioCompraCtrl,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: "Precio Compra",
                  labelStyle: TextStyle(color: nexusCyan),
                ),
              ),
              TextField(
                controller: precioVentaCtrl,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: "Precio Venta",
                  labelStyle: TextStyle(color: nexusCyan),
                ),
              ),
              TextField(
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: "Stock",
                  labelStyle: TextStyle(color: nexusCyan),
                ),
              ),
              TextField(
                controller: stockMinimoCtrl,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: "Stock Mínimo",
                  labelStyle: TextStyle(color: nexusCyan),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CANCELAR",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final url = ApiConfig.url('/producto/${producto['id']}');
                final res = await http.put(
                  Uri.parse(url),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "nombre": nombreCtrl.text,
                    "descripcion": descCtrl.text,
                    "precio_compra":
                        double.tryParse(precioCompraCtrl.text) ?? 0.0,
                    "precio_venta":
                        double.tryParse(precioVentaCtrl.text) ?? 0.0,
                    "stock": int.tryParse(stockCtrl.text) ?? 0,
                    "stock_minimo": int.tryParse(stockMinimoCtrl.text) ?? 0,
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
