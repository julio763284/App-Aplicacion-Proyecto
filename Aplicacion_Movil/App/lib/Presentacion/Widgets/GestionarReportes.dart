import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:gestor/Presentacion/Models/modelo.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class GestionarReportes extends StatefulWidget {
  const GestionarReportes({super.key});

  @override
  State<GestionarReportes> createState() => _InformesViewState();
}

class _InformesViewState extends State<GestionarReportes> {
  List<Informe> informes = [];
  DateTime? fechaFiltro;

  List<Informe> get informesFiltrados {
    if (fechaFiltro == null) return informes;

    return informes.where((informe) {
      return informe.fecha.year == fechaFiltro!.year &&
          informe.fecha.month == fechaFiltro!.month &&
          informe.fecha.day == fechaFiltro!.day;
    }).toList();
  }

  void agregarInforme() {
    setState(() {
      informes.add(
        Informe(
          id: Random().nextInt(999999).toString(),
          titulo: "Informe ${informes.length + 1}",
          descripcion: "Descripción del informe",
          fecha: DateTime.now(),
        ),
      );
    });
  }

  void editarInforme(Informe informe) {
    TextEditingController tituloController = TextEditingController(text: informe.titulo);
    TextEditingController descripcionController = TextEditingController(text: informe.descripcion);

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: const Color(0xFF162A2D),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Editar Informe", style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Título",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
                TextField(
                  controller: descripcionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar", style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF017A74)),
                onPressed: () {
                  setState(() {
                    informe.titulo = tituloController.text;
                    informe.descripcion = descripcionController.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Guardar"),
              ),
            ],
          ),
        );
      },
    );
  }

  void confirmarEliminacion(Informe informe) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: const Color(0xFF162A2D),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Eliminar Informe", style: TextStyle(color: Colors.white)),
            content: const Text("¿Estás seguro que deseas eliminar este informe?", style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar", style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  Navigator.pop(context);
                  eliminarInforme(informe.id);
                },
                child: const Text("Eliminar"),
              ),
            ],
          ),
        );
      },
    );
  }

  void eliminarInforme(String id) {
    setState(() {
      informes.removeWhere((informe) => informe.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Informe eliminado"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> seleccionarFecha() async {
    DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF017A74),
              onPrimary: Colors.white,
              surface: Color(0xFF0D1B1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      setState(() {
        fechaFiltro = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: accentTeal.withOpacity(0.2),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "GESTIONAR REPORTES",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.greenAccent),
            onPressed: seleccionarFecha,
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.sort, color: Colors.white70),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        foregroundColor: primaryDark,
        onPressed: agregarInforme,
        child: const Icon(Icons.add, size: 30),
      ),
      body: informesFiltrados.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late_outlined, size: 80, color: Colors.white.withOpacity(0.1)),
                  const SizedBox(height: 16),
                  Text("No hay reportes", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: informesFiltrados.length,
              itemBuilder: (context, index) {
                final informe = informesFiltrados[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF162A2D),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      informe.titulo,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(informe.descripcion, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.greenAccent),
                            const SizedBox(width: 5),
                            Text(
                              informe.fecha.toLocal().toString().split(' ')[0],
                              style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_document, color: Colors.white54, size: 22),
                          onPressed: () => editarInforme(informe),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                          onPressed: () => confirmarEliminacion(informe),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}