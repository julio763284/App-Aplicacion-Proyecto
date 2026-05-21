import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Pages/Home2Page.dart';

class HomepageBodyLayout extends StatelessWidget {
  const HomepageBodyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B1E), Color(0xFF002B28)],
          ),
        ),
        child: const SafeArea(
          child: Homepagebody(),
        ),
      ),
    );
  }
}