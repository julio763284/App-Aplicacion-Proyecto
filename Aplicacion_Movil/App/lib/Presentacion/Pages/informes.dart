import 'package:flutter/material.dart';
import 'dart:math';

import 'package:gestor/Presentacion/Models/modelo.dart';

class InformesView extends StatefulWidget {
  const InformesView({super.key});

  @override
  State<InformesView> createState() => _InformesViewState();
}

class _InformesViewState extends State<InformesView> {
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
    TextEditingController tituloController = TextEditingController(
      text: informe.titulo,
    );
    TextEditingController descripcionController = TextEditingController(
      text: informe.descripcion,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Informe"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
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
        );
      },
    );
  }

  void confirmarEliminacion(Informe informe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar Informe"),
          content: const Text(
            "¿Estás seguro que deseas eliminar este informe?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                eliminarInforme(informe.id);
              },
              child: const Text("Eliminar"),
            ),
          ],
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
        content: Text("Informe eliminado correctamente"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> seleccionarFecha() async {
    DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (fecha != null) {
      setState(() {
        fechaFiltro = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 122, 116),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Gestionar Reportes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: seleccionarFecha,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 1, 122, 116),
        onPressed: agregarInforme,
        child: const Icon(Icons.add),
      ),
      body: informesFiltrados.isEmpty
          ? const Center(
              child: Text(
                "No hay Reportes",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: informesFiltrados.length,
              itemBuilder: (context, index) {
                final informe = informesFiltrados[index];

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      informe.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "${informe.descripcion}\nFecha: ${informe.fecha.toLocal().toString().split(' ')[0]}",
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editarInforme(informe),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
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
