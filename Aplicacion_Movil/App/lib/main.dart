import 'package:flutter/material.dart';
import 'package:gestor/HomePage.dart';
import 'package:gestor/HomePage2.dart';
import 'package:gestor/Presentacion/Pages/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Pages/informes.dart';
import 'package:gestor/Presentacion/Pages/notificationView.dart';
import 'package:gestor/Presentacion/Pages/vistaDeRegistrarse.dart';
import 'package:gestor/Presentacion/Widgets/login.dart';
import 'package:gestor/Presentacion/Widgets/Loading.dart';

void main() {
  runApp(InventaryMobile());
}

class InventaryMobile extends StatelessWidget {
  const InventaryMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingView(),
    );
  }
}