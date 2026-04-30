import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/NuevoCliente.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/custom_app_bar.dart'; 

class Cliente extends StatefulWidget {
  const Cliente({super.key});

  @override
  State<Cliente> createState() => _ClienteState();
}

class _ClienteState extends State<Cliente> {
  // CLAVE: Inicializar siempre como lista vacía para que .isEmpty no falle
  List<dynamic> _todosLosClientes = [];
  List<dynamic> _clientesFiltrados = [];
  
  bool cargando = true;
  bool _estaBuscando = false; 
  int _conteoNotificaciones = 0;
  
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inicializarDatos();
  }

  Future<void> _inicializarDatos() async {
    await fetchClientes();
    await _obtenerNotificaciones();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _obtenerNotificaciones() async {
    try {
      final url = Uri.parse(ApiConfig.url('/notificaciones'));
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && mounted) {
          setState(() {
            _conteoNotificaciones = data.where((n) => n['leido'] == 0 || n['leido'] == false).length;
          });
        }
      }
    } catch (e) {
      debugPrint("Error notificaciones: $e");
    }
  }

  Future<void> fetchClientes() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/clientes')));
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        // Validar que los datos recibidos sean una lista
        final List<dynamic> data = (decodedData is List) ? decodedData : [];
        
        if (mounted) {
          setState(() {
            _todosLosClientes = data;
            _clientesFiltrados = data;
            cargando = false;
          });
        }
      } else {
        if (mounted) setState(() => cargando = false);
      }
    } catch (e) {
      debugPrint("Error fetchClientes: $e");
      if (mounted) setState(() => cargando = false);
    }
  }

  void _filtrarClientes(String query) {
    setState(() {
      _clientesFiltrados = _todosLosClientes.where((cliente) {
        final nombre = cliente['nombre']?.toString().toLowerCase() ?? '';
        return nombre.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(
        title: "CLIENTES",
        titleWidget: _estaBuscando 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const InputDecoration(
                hintText: "Buscar cliente...",
                hintStyle: TextStyle(color: Colors.white30),
                border: InputBorder.none,
              ),
              onChanged: _filtrarClientes,
            )
          : null,
        notificationCount: _conteoNotificaciones,
        onRefreshNotifications: _obtenerNotificaciones,
        onSearchPressed: () {
          setState(() {
            _estaBuscando = !_estaBuscando;
            if (!_estaBuscando) {
              _searchController.clear();
              _filtrarClientes('');
            }
          });
        },
        showProfile: true,
      ),
      body: cargando 
        ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
        : RefreshIndicator(
            onRefresh: _inicializarDatos,
            child: (_clientesFiltrados.isEmpty) 
              ? _buildEmptyState() 
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _clientesFiltrados.length,
                  itemBuilder: (context, index) => _buildClienteCard(_clientesFiltrados[index]),
                ),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, size: 30, color: primaryDark),
        onPressed: () => _mostrarMenuOpciones(context),
      ),
    );
  }

  Widget _buildClienteCard(Map<String, dynamic> cliente) {
    final String imagen = cliente['imagen'] ?? '';
    final String nombre = cliente['nombre'] ?? 'Sin nombre';
    final String fecha = cliente['fecha_registro'] ?? 'N/A';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF162A2D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          radius: 25,
          backgroundImage: imagen.isNotEmpty ? NetworkImage(imagen) : null,
          child: imagen.isEmpty 
            ? Text(nombre.isNotEmpty ? nombre[0].toUpperCase() : '?', 
                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))
            : null,
        ),
        title: Text(nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text("Registrado: $fecha", 
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.greenAccent),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            children: [
              Container(
                width: 170, height: 170,
                decoration: const BoxDecoration(color: Color(0xFF162A2D), shape: BoxShape.circle),
                child: Icon(
                  _estaBuscando ? Icons.search_off_rounded : Icons.person_add_alt_1_rounded, 
                  size: 80, 
                  color: Colors.greenAccent
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _estaBuscando ? "NO HAY COINCIDENCIAS" : "SIN CLIENTES", 
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _mostrarMenuOpciones(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF162A2D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add_rounded, color: Colors.greenAccent),
                title: const Text("Nuevo Cliente", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Nuevocliente())
                  ).then((_) => _inicializarDatos());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}