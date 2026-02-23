import 'package:flutter/material.dart';

class AjustesView extends StatelessWidget {
  const AjustesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Ajustes"),
        leading: const Icon(Icons.menu),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.info, color: Colors.teal),
            ),
          ),
        ],
      ),
      body: ListView(
        children: const [
          ItemAjuste(icono: Icons.settings, texto: "General"),
          ItemAjuste(icono: Icons.edit, texto: "Vista"),
          ItemAjuste(icono: Icons.business, texto: "Mi Empresa"),
          ItemAjuste(icono: Icons.price_change, texto: "Precios"),
          ItemAjuste(
            icono: Icons.qr_code,
            texto: "scanear De Codigo de Barras",
          ),
          ItemAjuste(icono: Icons.logout, texto: "Cerrar Sesión"),
          ItemAjuste(icono: Icons.person, texto: "Perfil"),
        ],
      ),
    );
  }
}

class ItemAjuste extends StatelessWidget {
  final IconData icono;
  final String texto;

  const ItemAjuste({super.key, required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icono, color: Colors.teal, size: 28),
      title: Text(texto, style: const TextStyle(fontSize: 18)),
      onTap: () {},
    );
  }
}
