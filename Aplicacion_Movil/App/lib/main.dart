import 'package:flutter/material.dart';
import 'package:gestor/Failure.dart';
import 'package:gestor/HomePage.dart';
import 'package:gestor/HomePage2.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/notificationView.dart';
import 'package:gestor/Presentacion/Widgets/vistaDeRegistrarse.dart';
import 'package:gestor/Presentacion/Widgets/login.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';

void main() {
  runApp(InventaryMobile());
}

class InventaryMobile extends StatelessWidget {
  const InventaryMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestionarInventarioPage(),
    );
  }
}
