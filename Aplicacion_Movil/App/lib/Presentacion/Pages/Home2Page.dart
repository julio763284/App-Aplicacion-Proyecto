import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o_Home/card_Home.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';

class Homepagebody extends StatelessWidget {
  const Homepagebody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 100),
      
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // tarjeta de Gestionar Productos //
            CardHome(
              text: "Gestionar Productos",
              icon: Icons.inventory,
              page: GestionarInventarioPage()),
              // tarjeta de Gestionar Reportes //
            CardHome(
              text: "Gestionar Reportes",
              icon: Icons.file_copy,
              page: const GestionarReportes()),
              // tarjeta de Visualizar Stock //
            CardHome(
              text: "Visualizar Stock",
              icon: Icons.inventory_rounded,
              page: const VisualizarStock()),
          ],
        ),
    
        const SizedBox(height: 50),
    
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // tarjeta de Gestionar Cliente //
            CardHome(
              text : "Gestionar Cliente",
              icon :  Icons.person,
              page: const Cliente()),
              // tarjeta de Gestionar Proveedores //
            CardHome(
              text : "Gestionar Proveedores",
              icon :  Icons.local_shipping,
              page: const Proveedores()),
              // tarjeta de Revisar Alertas //
            CardHome(
              text : "Revisar Alertas",
              icon :  Icons.warning,
              page: const NotificationView()),
          ],
        ),
    
        const SizedBox(height: 50),
    
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardHome(
              // tarjeta de Controlar Finanzas //
              text : "Controlar Finanzas",
              icon : Icons.monetization_on,
              page: const Controlar_Gastos()),
            CardHome(
              // tarjeta de Gestionar Inventario //
              text : "Gestionar Inventario",
              icon :  Icons.storefront,
              page: GestionarInventarioPage()),
            CardHome(
              // tarjeta de Configurar//
              text : "Configurar",
              icon :  Icons.settings,
              page: const Configuracion()),
          ],
        ),
      ],
    );
  }
}