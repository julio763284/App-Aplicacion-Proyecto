import 'package:flutter/material.dart';
import 'package:gestor/HomePage.dart';
import 'package:gestor/informes.dart';

void main() {
  runApp(InventaryMobile());
}

class InventaryMobile extends StatelessWidget {
  const InventaryMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
